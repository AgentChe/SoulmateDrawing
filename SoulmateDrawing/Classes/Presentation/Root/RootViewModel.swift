//
//  RootViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 08.01.2026.
//

import Foundation

@Observable
final class RootViewModel {
    private(set) var currentRoute: Router = .splash
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
    
    func makeInitialize() {
        sdkInitialize.observe { [weak self] in
            self?.login()
        }
    }
    
    func login() {
        
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        Task {
            await MainActor.run {
                screenState = .loaded
            }
            do {
                // TODO: Раскомментить
//                if anonymousId == internalId {
//                    try await profileManager.create()
//                } else {
//                    try await profileManager.binding()
//                }
                // TODO: Запросы нужных данных на старте
                async let discoverRequest = discoverManager.discover(forceUpdate: true)
                async let personListRequest = bondsManager.personList(forceUpdate: true)
                async let profileRequest = profileManager.getProfile(forceUpdate: true)
                
                let (_, _, _) = try await (discoverRequest, personListRequest, profileRequest)
                makeStartRoute()
            } catch {
                await MainActor.run {
                    screenState = .error
                }
            }
        }
    }
    
    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: Self.onboardingKey)
        currentRoute = .main
    }
    
    func makeStartRoute() {
        if UserDefaults.standard.bool(forKey: Self.onboardingKey) {
            currentRoute = .main
        } else {
            currentRoute = .onboarding
        }
    }
}

extension RootViewModel {
    enum Router {
        case splash
        case onboarding
        case main
    }
}

private extension RootViewModel {
    static let onboardingKey = "kOnboardingKey"
}
