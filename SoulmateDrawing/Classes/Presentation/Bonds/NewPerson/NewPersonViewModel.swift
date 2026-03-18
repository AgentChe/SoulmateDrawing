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
    var city: CityModel? = nil
    var screenState: ScreenState = .loaded
    
    var isSaving = false
    
    var isAvailableSave: Bool {
        let main = !name.isEmpty && city != nil && dayOfBorn != nil
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
    
    let coordinator: NewPersonCoordinator
    
    init(coordinator: NewPersonCoordinator) {
        self.coordinator = coordinator
    }
    
    func save() {
        guard let dayOfBorn, let city else { return }
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
            city: city.id,
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
                    coordinator.didCreatedPerson(person: model)
                }
            } catch {
                await MainActor.run {
                    screenState = .error { [weak self] in
                        self?.save()
                    }
                    isSaving = false
                }
            }
        }
    }
}

@MainActor
extension NewPersonViewModel {
    func openBornDate() {
        coordinator.showChangeDate(date: dayOfBorn) { [weak self] in
            self?.dayOfBorn = $0
            self?.coordinator.dismiss()
        }
    }
    
    func openBornTime() {
        coordinator.showChangeTime(date: timeOfBorn) { [weak self] in
            self?.timeOfBorn = $0
            self?.coordinator.dismiss()
        }
    }
    
    func openCity() {
        coordinator.showChangeCity(city: city?.address ?? "") { [weak self] in
            self?.city = $0
            self?.coordinator.dismiss()
        }
    }
}
