//
//  SplashViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 08.01.2026.
//

import Foundation

@Observable
final class SplashViewModel {
    private(set) var screenState: ScreenState = .loaded
    
    @ObservationIgnored
    private let sdkInitialize = SplashReceiptValidationObserver()
    @ObservationIgnored
    private let profileManager = ProfileManager()
    @ObservationIgnored
    private let sessionManager = SessionManager()
    @ObservationIgnored
    private let discoverManager = DiscoverManager()
    @ObservationIgnored
    private let bondsManager = BondsManager()
    
    let coordinator: SplashCoordinator
    
    init(coordinator: SplashCoordinator) {
        self.coordinator = coordinator
        makeInitialize()
    }
    
    func makeInitialize() {
        sdkInitialize.observe { [weak self] in
            self?.login()
        }
    }
    
    private func login() {
        
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        Task {
            await MainActor.run {
                screenState = .loaded
            }
            do {
                if anonymousId == internalId {
                    try await profileManager.create()
                } else {
                    try await profileManager.binding()
                }
                
                let _ = try await profileManager.getProfile(forceUpdate: true)
                makeStartRoute()
            } catch {
                await MainActor.run {
                    screenState = .error { [weak self] in
                        self?.login()
                    }
                }
            }
        }
    }
    
    func makeStartRoute() {
        if UserDefaults.standard.bool(forKey: Self.onboardingKey) {
            coordinator.showMain()
        } else {
            coordinator.showOnboarding()
        }
    }
}

extension SplashViewModel {
    static let onboardingKey = "kOnboardingKey"
}
