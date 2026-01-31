//
//  NewPersonViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.01.2026.
//

import Foundation

@Observable
final class NewPersonViewModel {
    var gender: GenderModel = .female
    var name: String = ""
    var dayOfBorn: Date?
    var timeOfBorn: Date?
    var city: String = ""
    var screenState: ScreenState = .loaded
    
    var isSaving = false
    
    var isAvailableSave: Bool {
        let main = !name.isEmpty && !city.isEmpty && dayOfBorn != nil
        return isKnownExtractTime ? main : main && timeOfBorn != nil
    }
    
    var isKnownExtractTime = false {
        willSet {
            if newValue {
                timeOfBorn = nil
            }
        }
    }
    
    @ObservationIgnored
    private let bondsManager = BondsManager()
    @ObservationIgnored
    private let createdPerson: (PersonModel) -> Void
    
    init(createdPerson: @escaping (PersonModel) -> Void) {
        self.createdPerson = createdPerson
    }
    
    func save() {
        guard let dayOfBorn else { return }
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.day, .month, .year], from: dayOfBorn)
        let timeComponents = timeOfBorn.map { timeOfBorn in
            Calendar.current.dateComponents([.hour, .minute], from: timeOfBorn)
        }
        
        dateComponents.hour = timeComponents?.hour
        dateComponents.minute = timeComponents?.minute
        guard let bornDate = calendar.date(from: dateComponents) else { return }
        
        let newPerson = NewPersonModel(
            name: name,
            bornDate: bornDate,
            city: city,
            gender: gender
        )
        
        Task {
            do {
                await MainActor.run {
                    isSaving = true
                    screenState = .loaded
                }
                
                let response = try await bondsManager.createPerson(newPerson)
                let model = PersonModel(from: response)
                await MainActor.run {
                    createdPerson(model)
                }
            } catch {
                await MainActor.run {
                    screenState = .error
                    isSaving = false
                }
            }
        }
    }
}
