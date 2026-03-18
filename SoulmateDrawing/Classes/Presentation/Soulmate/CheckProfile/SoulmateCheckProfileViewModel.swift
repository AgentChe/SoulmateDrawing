//
//  SoulmateCheckProfileViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 29.01.2026.
//

import Foundation

@Observable
final class SoulmateCheckProfileViewModel {
    private(set) var screenState: ScreenState = .loaded
    private(set) var profileName: String = ""
    private(set) var mainPoints: [MainPoint] = []
    private(set) var sign: URL?
    private(set) var profileInfo: [SoulmateProfileInfo] = []
    
    private(set) var soulmatePreferences: SoulmatePreferencesModel?
    private(set) var isGenerateSoulmate = false
    
    @ObservationIgnored
    private var selectedEthnicity: String?
    @ObservationIgnored
    private var selectedGender: String?
    
    @ObservationIgnored
    private let discoverManager = DiscoverManager()
    @ObservationIgnored
    private let profileManager = ProfileManager()
    @ObservationIgnored
    private let soulmateManager = SoulmateManager()
    
    private let coordinator: SoulmateCheckProfileCoordinator
    
    init(coordinator: SoulmateCheckProfileCoordinator) {
        self.coordinator = coordinator
        load()
    }
    
    private func load() {
        Task {
            do {
                await MainActor.run {
                    screenState = .loading
                }
                async let discoveryRequest = discoverManager.discover(forceUpdate: false)
                async let profileRequest = profileManager.getProfile(forceUpdate: false)
                async let soulmatePreferencesRequest = soulmateManager.preferences(forceUpdate: false)
                
                let (discovery, profile, soulmatePreferences) = try await (discoveryRequest, profileRequest, soulmatePreferencesRequest)
                
                let info = configureProfileInfo(profile: profile)
                
                await MainActor.run {
                    self.soulmatePreferences = soulmatePreferences
                    mainPoints = discovery.mainPoints
                    profileName = profile.name
                    profileInfo = info
                    sign = discovery.sign
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
    
    func generateSoulmate() {
        guard let selectedGender, let selectedEthnicity else { return }
        Task.detached { [weak self] in
            await MainActor.run { [weak self] in
                self?.isGenerateSoulmate = true
            }
            do {
                let soulmateResponse = try await self?.soulmateManager.generateSoulmate(gender: selectedGender, ethnicity: selectedEthnicity)
                guard let soulmate = soulmateResponse else { return }
                await MainActor.run { [weak self] in
                    self?.coordinator.openResult(model: soulmate)
                }
                
            } catch {
                await MainActor.run { [weak self] in
                    self?.isGenerateSoulmate = false
                    self?.screenState = .error { [weak self] in
                        self?.generateSoulmate()
                    }
                }
            }
        }
    }
    
    func updateProfile() {
        Task {
            let profile = try? await profileManager.getProfile(forceUpdate: false)
            
            guard let profile else { return }
            
            let info = configureProfileInfo(profile: profile)
            
            await MainActor.run {
                profileInfo = info
            }
        }
    }
    
    private func configureProfileInfo(profile: ProfileModel) -> [SoulmateProfileInfo] {
        let bornDate = profile.bornDate?.formatted(date: .long, time: .omitted) ?? ""
        let location = profile.city
        let time = profile.bornDate?.formatted(date: .omitted, time: .shortened) ?? ""
        
        return [
            .date(bornDate),
            .place(location),
            .time(time)
        ]
    }
}

@MainActor
extension SoulmateCheckProfileViewModel {
    func openSettings() {
        coordinator.openSettings()
    }
    
    func didSelect(ethnicity: String) {
        selectedEthnicity = ethnicity
        guard
            let genders = soulmatePreferences?.genders,
            !genders.isEmpty
        else { return }
        coordinator.showPreferences(elements: genders) { [weak self] item in
            self?.coordinator.dismiss()
            self?.didSelect(gender: item)
        }
    }
    
    func didSelect(gender: String) {
        selectedGender = gender
        generateSoulmate()
    }
    
    func didTapContinue() {
        guard
            let ethnicities = soulmatePreferences?.ethnicities,
            !ethnicities.isEmpty
        else { return }
        coordinator.showPreferences(elements: ethnicities) { [weak self] item in
            self?.coordinator.dismiss()
            self?.didSelect(ethnicity: item)
        }
    }
    
    func close() {
        coordinator.dismiss()
    }
}
