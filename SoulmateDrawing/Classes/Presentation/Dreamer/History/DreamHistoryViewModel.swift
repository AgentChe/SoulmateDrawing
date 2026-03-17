//
//  DreamHistoryViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.03.2026.
//

import Foundation

@Observable
final class DreamHistoryViewModel {
    private(set) var screenState: ScreenState = .loading
    private(set) var items: [DreamHistoryItem] = []
    
    
    @ObservationIgnored
    private let dreamerManager = DreamerManager()
    
    @ObservationIgnored
    private var pagination: Pagination?
    
    let coordinator: DreamerCoordinator
    
    init(coordinator: DreamerCoordinator) {
        self.coordinator = coordinator
        load()
    }
    
    private func load() {
        Task {
            do {
                await MainActor.run {
                    screenState = .loading
                }
                let response = try await dreamerManager.dreamHistory(page: nil)
                pagination = response.pagination
                let items: [DreamHistoryItem] = response.items.map(DreamHistoryItem.init)
                
                await MainActor.run {
                    self.items = items
                    self.screenState = .loaded
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
    
    func loadNext() {
        Task {
            guard let pagination, pagination.next > pagination.current else { return }
            let response = try await dreamerManager.dreamHistory(page: pagination.next)
            guard !Task.isCancelled else { return }
            
            self.pagination = response.pagination
            let elements = response.items.map(DreamHistoryItem.init)
            await MainActor.run {
                items.append(contentsOf: elements)
            }
        }
    }
    
    func showDetails(for id: String) {
        coordinator.showDetails(using: .load(id: id))
    }
}

extension DreamHistoryItem {
    init(_ item: DreamerHistoryResponse.Item) {
        self.init(
            id: item.id,
            date: SmartDateStyle().format(item.date),
            text: item.preview,
            image: item.image
        )
    }
}
