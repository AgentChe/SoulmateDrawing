//
//  DreamerMainViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 16.03.2026.
//

import Foundation

@Observable
final class DreamerMainViewModel {
    
    var text: String = ""
    
    private let coordinator: DreamerCoordinator
    
    init(coordinator: DreamerCoordinator) {
        self.coordinator = coordinator
    }
}

@MainActor
extension DreamerMainViewModel {
    func showDetails() {
        coordinator.showDetails(using: .interpret(dream: text))
    }
    
    func showHistory() {
        coordinator.showHistory()
    }
}
