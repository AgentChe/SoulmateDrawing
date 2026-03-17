//
//  HomeViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.01.2026.
//

import Foundation

extension HomeViewModel {
    enum Route: Identifiable {
        case settings
        case paygate
        case soulmateOnboarding
        case soulmateCheckProfile
        
        var id: Self { self }
    }
    
}

@Observable
final class HomeViewModel {
    private(set) var screenState: ScreenState = .loaded
    private(set) var profileName: String = ""
    private(set) var mainPoints: [MainPoint] = []
    private(set) var charts: [Chart] = []
    private(set) var sign: URL?
    var selectionSegment: HomeSegmentItem = .explore
    var hasActiveSubscription: Bool {
        return sessionManager.hasActiveSubscriptions()
    }
    
    var fullScreen: Route?
    var push: MainRoute?
    var switchTab: TabElement?
    
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
        load()
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
    
    
    @MainActor
    func selectedExplore(_ item: ExploreType) {
        switch item {
        case .soulmate:
            if let soulmate {
                coordinator.openSoulmate(model: soulmate)
//                push = .soulmateResult(soulmate)
            } else {
                coordinator.openOnboarding()
//                fullScreen = .soulmateOnboarding
            }
        case .dream:
//            switchTab = .dreamer
            coordinator.showDreamer()
        case .relationship:
//            switchTab = .bonds
            coordinator.showBonds()
        }
    }
//    
    func showPaygate() {
        coordinator.showPaygate()
//        fullScreen = .paygate
    }
    
    func showSettings() {
        coordinator.showSettings()
//        fullScreen = .settings
    }
}
