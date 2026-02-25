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
    
    var actionIsEnabled: Bool {
        person != nil && connectionType != nil
    }
    
    @ObservationIgnored
    private let bondsManager = BondsManager()
    @ObservationIgnored
    private let chatManager = AIChatManager()
    
    init() {
        load()
    }
    
    func load() {
        Task {
            do {
                async let personListRequest = bondsManager.personList(forceUpdate: false)
                async let historyRequest = chatManager.getHistory(page: nil)
                
                let (personList, history) = try await (personListRequest, historyRequest)
                insights = history.items.map(InsightModel.init)
                persons = personList.map(PersonModel.init)
                screenState = .loaded
            } catch {
                await MainActor.run {
                    screenState = .error
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
                }
            } catch {
                await MainActor.run {
                    isDescovering = false
                }
            }
        }
    }
    
//    func openInsightsList() {
//        coordinator.push(.insightsList(models: insights))
//    }
//    
//    func openConnectionType() {
//        coordinator.sheet(.connectionType { [weak self] in
//            self?.connectionType = $0
//        })
//    }
//    
//    func openSelectPerson() {
//        if persons.isEmpty {
//            coordinator.sheet(.newPerson { [weak self] in
//                self?.selectPerson(person: $0)
//            })
//        } else {
//            coordinator.sheet(.personList(persons: persons, selected: { [weak self] in
//                self?.selectPerson(person: $0)
//            }))
//        }
//    }
}


extension InsightModel {
    init(response: AIChatHistoryResponse.Item) {
        self.id = response.threadId
        // TODO: Поправить форматирование
        self.formattedDate = ""
        self.text = response.message.content
        self.pairText = "Bonds.You".localized + " & " + response.personName
        self.connectionType = response.petsonType
    }
}
