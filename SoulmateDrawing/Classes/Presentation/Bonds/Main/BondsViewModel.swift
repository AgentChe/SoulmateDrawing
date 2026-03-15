//
//  BondsViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import Foundation

struct InsightModel: Identifiable, Hashable {
    let id: String
    let formattedDate: String
    let text: String
    let pairText: String
    let connectionType: ConnectionType
}

@Observable
final class BondsViewModel {
    
    private(set)var connectionType: ConnectionType?
    private(set) var persons: [PersonModel] = []
    private(set) var person: PersonModel?
    private(set) var screenState: ScreenState = .loading
    private(set) var insights: [InsightModel] = []
    private(set) var isDescovering = false
    private(set) var isAvailablePagination = true
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
    
    func load() {
        Task {
            do {
                async let personListRequest = bondsManager.personList(page: nil)
                async let historyRequest = chatManager.getHistory(page: nil)
                async let discoveryRequest = discoverManager.discover(forceUpdate: true)
                
                let (personList, history, discovery) = try await (personListRequest, historyRequest, discoveryRequest)
                await MainActor.run {
                    pagination = history.pagination
                    isAvailablePagination = history.pagination.current <  history.pagination.total
                    
                    userSign = discovery.sign
                    insights = history.items.map(InsightModel.init)
                    persons = personList.items.map(PersonModel.init)
                    screenState = .loaded
                }
            } catch {
                await MainActor.run {
                    screenState = .error
                }
            }
        }
    }
    
    func getNextPage() {
        guard (paginationTask?.isCancelled ?? true), let pagination, pagination.current < pagination.total else { return }
        
        paginationTask = Task {
            do {
                let history = try await chatManager.getHistory(page: pagination.next)
                let newInsights = history.items.map(InsightModel.init)
                
                await MainActor.run {
                    insights.append(contentsOf: newInsights)
                }
            } catch {
                
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
                    push = .chat(.start(threadID: result.threadID, insight: result.insight, tips: result.tips))
                }
            } catch {
                await MainActor.run {
                    isDescovering = false
                }
            }
        }
    }
}


extension InsightModel {
    init(response: ChatHistoryResponse.Item) {
        self.id = response.threadId
        self.formattedDate = SmartDateStyle().format(response.createdDate)
        self.text = response.message.content
        self.pairText = "Bonds.You".localized + " & " + response.personName
        self.connectionType = response.petsonType
    }
}

struct SmartDateStyle: FormatStyle {
    typealias FormatInput = Date
    typealias FormatOutput = String
    
    func format(_ value: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(value) {
            return "Сегодня"
        }
        
        if calendar.isDateInYesterday(value) {
            return "Вчера"
        }
        
        // Для остальных дат используем стандартный формат
        let style = Date.FormatStyle()
            .day(.defaultDigits)
            .month(.abbreviated)
            .locale(Locale(identifier: "ru_RU"))
        
        return style.format(value)
    }
}
