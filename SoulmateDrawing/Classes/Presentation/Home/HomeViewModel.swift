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
    
    @ObservationIgnored
    private let discoverManager = DiscoverManager()
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
                async let discoveryRequest = discoverManager.discover(forceUpdate: false)
                async let profileRequest = profileManager.getProfile(forceUpdate: false)
                
                let (discovery, profile) = try await (discoveryRequest, profileRequest)
                
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
}
