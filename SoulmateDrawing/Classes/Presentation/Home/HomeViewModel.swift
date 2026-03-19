//
//  HomeViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.01.2026.
//

import Foundation

@Observable
final class HomeViewModel {
    private(set) var screenState: ScreenState = .loaded
    private(set) var profileName: String = ""
    private(set) var mainPoints: [MainPoint] = []
    private(set) var charts: [Chart] = []
    private(set) var sign: URL?
    var selectionSegment: HomeSegmentItem = .explore
    private(set) var hasActiveSubscription: Bool
    
    @ObservationIgnored
    private let discoverManager = DiscoverManager()
    @ObservationIgnored
    private let profileManager = ProfileManager()
    @ObservationIgnored
    private let soulmateManager = SoulmateManager()
    @ObservationIgnored
    private let sessionManager = SessionManager()
    
    @ObservationIgnored
    private var soulmate: SoulmateModel?
    
    private let coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        hasActiveSubscription = sessionManager.hasActiveSubscriptions()
        load()
        settingsObservation()
    }
    
    private func load() {
        Task {
            do {
                await MainActor.run {
                    screenState = .loading
                }
                async let discoveryRequest = discoverManager.discover(forceUpdate: true)
                async let profileRequest = profileManager.getProfile(forceUpdate: true)
                async let soulmateRequest = soulmateManager.soulmate()
                
                let (discovery, profile, soulmate) = try await (discoveryRequest, profileRequest, soulmateRequest)
                
                self.soulmate = soulmate
                
                await MainActor.run {
                    mainPoints = discovery.mainPoints
                    charts = discovery.charts
                    sign = discovery.sign
                    profileName = profile.name
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
    
    private func settingsObservation() {
        Task(priority: .userInitiated) {
            for await _ in ObservationManager.shared.settingsUpdated {
                do {
                    async let profileRequest = profileManager.getProfile(forceUpdate: false)
                    async let discoveryRequest = discoverManager.discover(forceUpdate: true)
                    async let soulmateRequest = soulmateManager.soulmate()
                    let (discovery, profile, soulmate) = try await (discoveryRequest, profileRequest, soulmateRequest)
                    
                    self.soulmate = soulmate
                    
                    await MainActor.run {
                        mainPoints = discovery.mainPoints
                        charts = discovery.charts
                        sign = discovery.sign
                        profileName = profile.name
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
    }
}

@MainActor
extension HomeViewModel {
    func selectedExplore(_ item: ExploreType) {
        switch item {
        case .soulmate:
            if let soulmate {
                coordinator.openSoulmate(model: soulmate)
            } else {
                coordinator.openOnboarding()
            }
        case .dream:
            coordinator.showDreamer()
        case .relationship:
            coordinator.showBonds()
        }
    }
    
    func showPaygate() {
        coordinator.showPaygate()
    }
    
    func showSettings() {
        coordinator.showSettings()
    }
    
    func checkActiveSubscription() {
        hasActiveSubscription = sessionManager.hasActiveSubscriptions()
    }
}
