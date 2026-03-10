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
    var selectionSegment: HomeSegmentItem = .explore
    
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
    private var soulmate: SoulmateModel?
    
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
                async let soulmateRequest = soulmateManager.soulmate()
                
                let (discovery, profile, soulmate) = try await (discoveryRequest, profileRequest, soulmateRequest)
                
                self.soulmate = soulmate
                
                await MainActor.run {
                    mainPoints = discovery.mainPoints
                    charts = discovery.charts
                    profileName = profile.name
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
    func selectedExplore(_ item: ExploreType) {
        switch item {
        case .soulmate:
            if let soulmate {
                push = .soulmateResult(soulmate)
            } else {
                fullScreen = .soulmateOnboarding
            }
        case .dream:
            switchTab = .dreamer
        case .relationship:
            switchTab = .bonds
        }
    }
//    
    func showPaygate() {
        fullScreen = .paygate
    }
    
    func showSettings() {
        fullScreen = .settings
    }
}
