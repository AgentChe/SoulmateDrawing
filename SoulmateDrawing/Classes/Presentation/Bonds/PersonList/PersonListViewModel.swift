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
    
    init(persons: [PersonModel]) {
        self.persons = persons
    }
}
