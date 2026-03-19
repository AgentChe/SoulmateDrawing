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
    private(set) var hasActiveSubscription: Bool
    
    private(set) var profile: ProfileModel?
    @ObservationIgnored
    private let profileManager = ProfileManager()
    @ObservationIgnored
    private let sessionManager = SessionManager()
    let coordinator: SettingsCoordinator
    
    init(coordinator: SettingsCoordinator) {
        self.coordinator = coordinator
        self.hasActiveSubscription = sessionManager.hasActiveSubscriptions()
        load()
    }
    
    private func load() {
        Task {
            do {
                await MainActor.run {
                    screenState = .loading
                }
                let profile = try await profileManager.getProfile(forceUpdate: true)
                
                await MainActor.run {
                    self.profile = profile
                    configureDataSource()
                    screenState = .loaded
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
    
    func save(date: Date) {
        profile?.bornDate = date
        updateProfile(attrs: ["birth_datetime": Int(date.timeIntervalSince1970)])
    }
    
    private func updateProfile(attrs: [String: Any?]) {
        Task {
            await MainActor.run {
                screenState = .loading
            }
            do {
                try await profileManager.saveAttributes(attrs: attrs)
                let profile = try? await profileManager.getProfile(forceUpdate: true)
                ObservationManager.shared.settingsDidUpdated()
                
                await MainActor.run {
                    if let profile {
                        self.profile = profile
                    }
                    configureDataSource()
                    screenState = .loaded
                }
            } catch {
                await MainActor.run {
                    screenState = .error { [weak self] in
                        self?.updateProfile(attrs: attrs)
                    }
                }
            }
        }
    }
    
    func save(city: CityModel) {
        profile?.city = city.address
        updateProfile(attrs: ["birth_location": city.id] )
    }
}

@MainActor
extension SettingsViewModel {
    func open(item: ProfileSection.Model) {
        switch item {
        case .date:
            coordinator.showChangeDate(date: profile?.bornDate) { [weak self] newDate in
                self?.save(date: newDate)
                self?.coordinator.dismiss()
            }
        case .place:
            coordinator.showChangeCity(city: profile?.city ?? "") { [weak self] model in
                self?.save(city: model)
                self?.coordinator.dismiss()
            }
        case .time:
            coordinator.showChangeTime(date: profile?.bornDate) { [weak self] newDate in
                self?.save(date: newDate)
                self?.coordinator.dismiss()
            }
        case .privacyPolicy:
            coordinator.open(url: GlobalDefinitions.privacyPolicy)
        case .termOfUse:
            coordinator.open(url: GlobalDefinitions.termsOfUse)
        case .contactUs:
            coordinator.open(url: GlobalDefinitions.support)
        }
    }
    
    func close() {
        coordinator.dismiss()
    }
    
    func showPaygate() {
        coordinator.showPaygate()
    }
    
    func checkActiveSubscription() {
        hasActiveSubscription = sessionManager.hasActiveSubscriptions()
    }
}

private extension SettingsViewModel {
    @MainActor
    func configureDataSource() {
        let date = profile?.bornDate?.formatted(date: .long, time: .omitted)
        let location = profile?.city ?? ""
        let time = profile?.bornDate?.formatted(date: .omitted, time: .shortened)
        
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
        
        sections = profileInfo
    }
}
