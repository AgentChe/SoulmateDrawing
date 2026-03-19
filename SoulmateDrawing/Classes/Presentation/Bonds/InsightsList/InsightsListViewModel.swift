//
//  InsightsListViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 16.03.2026.
//

import Foundation

@Observable
final class InsightsListViewModel {
    private(set) var screenState: ScreenState = .loading
    private(set) var items: [InsightModel] = []
    private(set) var isLoading = false
    
    @ObservationIgnored
    private var pagination: Pagination?
    @ObservationIgnored
    private let chatManager = ChatManager()
    
    private let coordinator: BondsCoordinator
    
    init(coordinator: BondsCoordinator) {
        self.coordinator = coordinator
        load()
        chatObservation()
    }
    
    private func load() {
        Task {
            do {
                await MainActor.run {
                    screenState = .loading
                }
                let items = try await loadHistory()
                
                await MainActor.run {
                    self.items = items
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
    
    private func loadHistory() async throws -> [InsightModel] {
        let response = try await chatManager.getHistory(page: pagination?.next)
        
        pagination = response.pagination
        return response.items.map(InsightModel.init)
    }
    
    private func chatObservation() {
        Task(priority: .userInitiated) {
            for await _ in ObservationManager.shared.chatsUpdated {
                await MainActor.run {
                    pagination = nil
                }
                
                let history = try? await chatManager.getHistory(page: nil)
                guard let history else { return }
                
                let insightsItems = history.items.map(InsightModel.init)
                
                await MainActor.run {
                    items = insightsItems
                    pagination = history.pagination
                }
            }
        }
    }
    
    func loadNext() {
        guard let pagination, pagination.next > pagination.current, !isLoading else { return }
        
        Task {
            do {
                await MainActor.run {
                    isLoading = true
                }
                let response = try await chatManager.getHistory(page: pagination.next)
                self.pagination = response.pagination
                let items = response.items.map(InsightModel.init)
                
                await MainActor.run {
                    isLoading = false
                    self.items.append(contentsOf: items)
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
}

@MainActor
extension InsightsListViewModel {
    func openChat(for model: InsightModel) {
        coordinator.openChat(using: ChatModel(model: model))
    }
}
