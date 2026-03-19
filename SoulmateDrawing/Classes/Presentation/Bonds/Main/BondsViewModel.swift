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
    
    var actionIsEnabled: Bool {
        person != nil && connectionType != nil
    }
    
    @ObservationIgnored
    private let bondsManager = BondsManager()
    @ObservationIgnored
    private let chatManager = ChatManager()
    @ObservationIgnored
    private let sessionManager = SessionManager()
    @ObservationIgnored
    private let discoverManager = DiscoverManager()
    
    private let coordinator: BondsCoordinator
    
    init(coordinator: BondsCoordinator) {
        self.coordinator = coordinator
        load()
        chatObservation()
    }
    
    private func load() {
        Task {
            do {
                async let personListRequest = bondsManager.personList(page: nil)
                async let historyRequest = chatManager.getHistory(page: nil)
                async let discoveryRequest = discoverManager.discover(forceUpdate: true)
                
                let (personList, history, discovery) = try await (personListRequest, historyRequest, discoveryRequest)
                let insightsItems = history.items.map(InsightModel.init)
                let personsItems = personList.items.map(PersonModel.init)
                
                await MainActor.run {
                    userSign = discovery.sign
                    insights = insightsItems
                    persons = personsItems
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
    
    private func chatObservation() {
        Task(priority: .userInitiated) {
            for await _ in ObservationManager.shared.chatsUpdated {
                let history = try? await chatManager.getHistory(page: nil)
                guard let history else { return }
                
                let insightsItems = history.items.map(InsightModel.init)
                
                await MainActor.run {
                    insights = insightsItems
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
        if sessionManager.hasActiveSubscriptions() {
            createThread(person: person, connectionType: connectionType)
        } else {
            coordinator.showPaygate()
        }
    }
    
    private func createThread(person: PersonModel, connectionType: ConnectionType) {
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
                }
            } catch {
                await MainActor.run {
                    isDescovering = false
                }
            }
        }
    }
}

@MainActor
extension BondsViewModel {
    func openPersonList() {
        if persons.isEmpty {
            coordinator.createPerson { [weak self] in
                self?.selectPerson(person: $0)
            }
        } else {
            coordinator.openPersonList { [weak self] in
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
