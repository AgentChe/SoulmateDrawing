//
//  SettingsViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 29.01.2026.
//

import Foundation

@Observable
final class SettingsViewModel {
    private(set) var screenState: ScreenState = .loaded
    private(set) var sections: [ProfileSection] = []
    
    @ObservationIgnored
    private(set) var bornDate: Date?
    @ObservationIgnored
    private(set) var city: String = ""
    
    @ObservationIgnored
    private let profileManager = ProfileManager()
    
    init() {
        load()
    }
    
    func load() {
        Task {
            do {
                await MainActor.run {
                    screenState = .loading
                }
                let profile = try await profileManager.getProfile(forceUpdate: true)
                self.bornDate = profile.bornDate
                self.city = profile.city
                
                await configureDataSource()
                
                await MainActor.run {
                    screenState = .loaded
                }
                
            } catch {
                await MainActor.run {
                    screenState = .error
                }
            }
        }
    }
    
    func save(date: Date) {
        bornDate = date
        // TODO: Реализовать сохранение
        Task {
            await configureDataSource()
        }
    }
    
    func save(city: String) {
        self.city = city
        Task {
            await configureDataSource()
        }
    }
    
//    func open(item: ProfileSection.Model) {
//        switch item {
//        case .date:
//            coordinator.sheet(.dateOfBird(current: bornDate ?? .init(), selected: { [weak self] in
//                self?.bornDate = $0
//            }))
//        case .place:
//            coordinator.sheet(.placeOfBird(current: city, selected: { [weak self] in
//                self?.city = $0
//            }))
//        case .time:
//            coordinator.sheet(.timeOfBird(current: bornDate ?? .init(), selected: { [weak self] in
//                self?.bornDate = $0
//            }))
//        case .privacyPolicy:
//            break
//        case .termOfUse:
//            break
//        case .contactUs:
//            break
//        }
//    }
}

private extension SettingsViewModel {
    func configureDataSource() async {
        let date = bornDate?.formatted(date: .long, time: .omitted)
        let location = city
        let time = bornDate?.formatted(date: .omitted, time: .shortened)
        
        let profileInfo: [ProfileSection] = [
            .init(
                id: "1",
                title: "Profile.Section.Personal".localized,
                items: [
                    .date(date),
                    .place(location),
                    .time(time)
                ]
            ),
            .init(
                id: "2",
                title: "Profile.Section.Help".localized,
                items: [
                    .privacyPolicy,
                    .termOfUse,
                    .contactUs
                ]
            )
        ]
        
        await MainActor.run {
            sections = profileInfo
        }
    }
}
