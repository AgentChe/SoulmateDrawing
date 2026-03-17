//
//  PersonListViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 12.01.2026.
//

import Foundation


@Observable
final class PersonListViewModel {
    private(set) var persons: [PersonModel]
    
    @ObservationIgnored
    private let bondsManager = BondsManager()
    
    let coordinator: BondsCoordinator
    private let didSelect: (PersonModel) -> Void
    
    init(coordinator: BondsCoordinator, persons: [PersonModel], selected: @escaping (PersonModel) -> Void) {
        self.coordinator = coordinator
        self.didSelect = selected
        self.persons = persons
    }
    
    func select(person: PersonModel) {
        didSelect(person)
    }
    
    func createNew() {
        coordinator.createPerson(createdPerson: didSelect)
    }
}
