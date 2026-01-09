//
//  OnboardingViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.12.2025.
//

import Foundation
import SwiftUI

@Observable final class OnboardingViewModel {
    var user: UserModel
    @ObservationIgnored
    let onboardings: [OnboardingElement]
    var currentOnboarding: OnboardingElement
    var screenState: ScreenState = .loaded
    
    private var _searchCity = ""
    
    private(set) var isFinish = false
    
    var progress: Double {
        guard let index = onboardings.firstIndex(of: currentOnboarding) else { return 0 }
        return Double(index) / Double(onboardings.count - 1)
    }
    
    private var saveUserTask: Task<Void, Never>?
    @ObservationIgnored
    private let profileManager = ProfileManager()
    
    init() {
        onboardings = OnboardingElement.allCases
        currentOnboarding = .welcome
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
        saveUserTask = Task {
            screenState = .loading
            do {
                guard Task.isCancelled else { return }
                try await profileManager.saveAttributes(user: user)
                isFinish = true
            } catch {
                guard Task.isCancelled else { return }
                screenState = .error
            }
        }
    }
}
