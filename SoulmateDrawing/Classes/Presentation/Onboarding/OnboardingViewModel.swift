//
//  OnboardingViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.12.2025.
//

import Foundation
import SwiftUI

@Observable final class OnboardingViewModel {
    var user: ProfileModel
    @ObservationIgnored
    let onboardings: [OnboardingElement]
    var currentOnboarding: OnboardingElement
    var screenState: ScreenState = .loaded
    
    private(set) var isFinish = false
    
    var progress: Double {
        guard let index = onboardings.firstIndex(of: currentOnboarding) else { return 0 }
        return Double(index) / Double(onboardings.count - 1)
    }
    
    @ObservationIgnored
    private var saveUserTask: Task<Void, Never>?
    @ObservationIgnored
    private let profileManager = ProfileManager()
    
    init() {
        onboardings = OnboardingElement.allCases
        currentOnboarding = .name
        user = .init(name: "", bornDate: .init(), city: "")
    }
    
    func didTapContinue() {
        guard let index = onboardings.firstIndex(of: currentOnboarding) else {
            saveData()
            return
        }
        let newIndex = index + 1
        guard newIndex <= onboardings.count - 1 else {
            saveData()
            return
        }
        currentOnboarding = onboardings[newIndex]
    }
    
    func saveData() {
        saveUserTask?.cancel()
        
        saveUserTask = Task {
            await MainActor.run {
                screenState = .loading
            }
            do {
                let attrs: [String: Any?] = [
                    "name": user.name,
                    "birth_datetime": user.bornDate.map { Int($0.timeIntervalSince1970) },
                    "birth_location": user.city
                ]
                try await profileManager.saveAttributes(attrs: attrs)
                _ = try? await profileManager.getProfile(forceUpdate: true)
                await MainActor.run {
                    isFinish = true
                }
            } catch {
                await MainActor.run {
                    screenState = .error
                }
            }
        }
    }
}
