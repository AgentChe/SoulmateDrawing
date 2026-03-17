//
//  BondsViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import Foundation

@Observable
final class BondsViewModel {
    
    private(set)var connectionType: ConnectionType?
    private(set) var persons: [PersonModel] = []
    private(set) var person: PersonModel?
    private(set) var screenState: ScreenState = .loading
    private(set) var insights: [InsightModel] = []
    private(set) var isDescovering = false
    private(set) var userSign: URL?
    var hasActiveSubscription: Bool {
        return sessionManager.hasActiveSubscriptions()
    }
    
    var push: MainRoute?
    
    var actionIsEnabled: Bool {
        person != nil && connectionType != nil
    }
    
    @ObservationIgnored
    private var pagination: Pagination?
    @ObservationIgnored
    private let bondsManager = BondsManager()
    @ObservationIgnored
    private let chatManager = ChatManager()
    @ObservationIgnored
    private let sessionManager = SessionManager()
    @ObservationIgnored
    private let discoverManager = DiscoverManager()
    @ObservationIgnored
    private var paginationTask: Task<Void, Never>?
    
    let coordinator: BondsCoordinator
    
    init(coordinator: BondsCoordinator) {
        self.coordinator = coordinator
        load()
    }
    
    private func load() {
        Task {
            do {
                async let personListRequest = bondsManager.personList(page: nil)
                async let historyRequest = chatManager.getHistory(page: nil)
                async let discoveryRequest = discoverManager.discover(forceUpdate: true)
                
                let (personList, history, discovery) = try await (personListRequest, historyRequest, discoveryRequest)
                await MainActor.run {
                    pagination = history.pagination
                    
                    userSign = discovery.sign
                    insights = history.items.map(InsightModel.init)
                    persons = personList.items.map(PersonModel.init)
                    screenState = .loaded
                }
            } catch {
                await MainActor.run {
                    screenState = .error { [weak self] in
                        self?.load()
                    }
                }
            }
        }
    }
    
    
    
    func selectPerson(person: PersonModel) {
        self.person = person
        if !persons.contains(where: { $0.id == person.id }) {
            persons.append(person)
        }
    }
    
    func selectConnectionType(_ type: ConnectionType) {
        connectionType = type
    }
    
    func tapDiscover() {
        guard let person, let connectionType else { return }
        Task {
            do {
                await MainActor.run {
                    isDescovering = true
                }
                let result = try await chatManager.createThread(for: person.id, use: connectionType)
                await MainActor.run {
                    isDescovering = false
                    let model = ChatModel(
                        threadID: result.threadID,
                        personName: person.name,
                        personType: connectionType,
                        tips: .init(
                            insight: result.insight,
                            tips: result.tips
                        )
                    )
                    coordinator.openChat(using: model)
//                    push = .chat(.start(threadID: result.threadID, insight: result.insight, tips: result.tips))
                }
            } catch {
                await MainActor.run {
                    isDescovering = false
                }
            }
        }
    }
    
    func openPersonList() {
        if persons.isEmpty {
            coordinator.createPerson { [weak self] in
                self?.selectPerson(person: $0)
            }
        } else {
            coordinator.openPersonList(persons: persons) { [weak self] in
                self?.selectPerson(person: $0)
            }
        }
    }
    
    func openConnectionType() {
        coordinator.connectionType { [weak self] in
            self?.connectionType = $0
        }
    }
    
    func openInsightList() {
        coordinator.insigtsList()
    }
    
    func openChat(model: InsightModel) {
        coordinator.openChat(using: ChatModel(model: model))
    }
}
