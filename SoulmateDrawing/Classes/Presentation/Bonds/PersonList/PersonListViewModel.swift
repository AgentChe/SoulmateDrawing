//
//  PersonListViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 12.01.2026.
//

import Foundation

@Observable
final class PersonListViewModel {
    private(set) var screenState: ScreenState = .loaded
    private(set) var persons: [PersonModel] = []
    private(set) var isLoading: Bool = false
    
    @ObservationIgnored
    private var pagination: Pagination?
    @ObservationIgnored
    private let bondsManager = BondsManager()
    
    let coordinator: BondsCoordinator
    private let didSelect: (PersonModel) -> Void
    
    init(coordinator: BondsCoordinator, selected: @escaping (PersonModel) -> Void) {
        self.coordinator = coordinator
        self.didSelect = selected
        
        self.load()
    }
    
    private func load() {
        Task {
            screenState = .loading
            do {
                let response = try await bondsManager.personList(page: nil)
                pagination = response.pagination
                let items = response.items.map(PersonModel.init)
                await MainActor.run {
                    persons = items
                    screenState = .loaded
                }
                
            } catch {
                screenState = .error { [weak self] in
                    self?.load()
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
                let response = try await bondsManager.personList(page: pagination.next)
                self.pagination = response.pagination
                let items = response.items.map(PersonModel.init)
                
                await MainActor.run {
                    isLoading = false
                    self.persons.append(contentsOf: items)
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
    
    func select(person: PersonModel) {
        didSelect(person)
    }
    
    func createNew() {
        coordinator.createPerson(createdPerson: didSelect)
    }
}
