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
    
    let coordinator: DreamerCoordinator
    
    init(coordinator: DreamerCoordinator) {
        self.coordinator = coordinator
    }
    
    func showDetails() {
        coordinator.showDetails(using: .interpret(dream: text))
    }
    
    func showHistory() {
        coordinator.showHistory()
    }
}
