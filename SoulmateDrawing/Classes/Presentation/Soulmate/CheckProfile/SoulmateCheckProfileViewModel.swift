//
//  SoulmateCheckProfileViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 29.01.2026.
//

import Foundation

extension SoulmateCheckProfileViewModel {
    enum SheetType: Identifiable {
        case ethnicity([String])
        case gender([String])
        
        var id: String {
            switch self {
            case .ethnicity(let array):
                array.joined(separator: "_")
            case .gender(let array):
                array.joined(separator: "_")
            }
        }
    }
    
    enum FullScreen: Identifiable {
        case settings
        
        var id: Self { self }
    }
    
    enum Push: Equatable {
        case soulmateResult(SoulmateModel)
    }
}

@Observable
final class SoulmateCheckProfileViewModel {
    private(set) var screenState: ScreenState = .loaded
    private(set) var profileName: String = ""
    private(set) var mainPoints: [MainPoint] = []
    private(set) var profileInfo: [SoulmateProfileInfo] = []
    
    private(set) var soulmatePreferences: SoulmatePreferencesModel?
    private(set) var isGenerateSoulmate = false
    
    var sheetType: SheetType?
    var fullScreen: FullScreen?
    var push: Push?
    
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
    
    init() {
        load()
    }
    
    func load() {
        Task {
            do {
                await MainActor.run {
                    screenState = .loading
                }
                async let discoveryRequest = discoverManager.discover(forceUpdate: false)
                async let profileRequest = profileManager.getProfile(forceUpdate: false)
                async let soulmatePreferencesRequest = soulmateManager.preferences(forceUpdate: false)
                
                let (discovery, profile, soulmatePreferences) = try await (discoveryRequest, profileRequest, soulmatePreferencesRequest)
                let bornDate = profile.bornDate?.formatted(date: .long, time: .omitted) ?? ""
                let location = profile.city
                let time = profile.bornDate?.formatted(date: .omitted, time: .shortened) ?? ""
                
                let info: [SoulmateProfileInfo] = [
                    .date(bornDate),
                    .place(location),
                    .time(time)
                ]
                
                await MainActor.run {
                    self.soulmatePreferences = soulmatePreferences
                    mainPoints = discovery.mainPoints
                    profileName = profile.name
                    profileInfo = info
                    screenState = .loaded
                }
            } catch {
                await MainActor.run {
                    screenState = .error
                }
            }
        }
    }
    
    @MainActor
    func openSettings() {
        fullScreen = .settings
    }
    
    @MainActor
    func didSelect(ethnicity: String) {
        selectedEthnicity = ethnicity
        guard
            let genders = soulmatePreferences?.genders,
            !genders.isEmpty
        else { return }
        
        sheetType = .gender(genders)
    }
    
    @MainActor
    func didSelect(gender: String) {
        selectedGender = gender
        sheetType = nil
        generateSoulmate()
    }
    
    @MainActor
    func didTapContinue() {
        guard
            let ethnicities = soulmatePreferences?.ethnicities,
            !ethnicities.isEmpty
        else { return }
        
        sheetType = .ethnicity(ethnicities)
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
                    self?.push = .soulmateResult(soulmate)
                }
                
            } catch {
                await MainActor.run { [weak self] in
                    self?.isGenerateSoulmate = false
                    self?.screenState = .error
                }
            }
        }
    }
}
