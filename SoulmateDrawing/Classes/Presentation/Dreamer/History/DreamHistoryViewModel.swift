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
    
    init() {
        load()
    }
    
    func load() {
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
                    screenState = .error
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
}

extension DreamHistoryItem {
    init(_ item: DreamerHistoryResponse.Item) {
        let formattedDate = Date(timeIntervalSince1970: TimeInterval(item.date)).formatted(date: .omitted, time: .shortened)
        self.init(
            id: item.id,
            date: formattedDate,
            text: item.preview,
            image: item.image
        )
    }
}
