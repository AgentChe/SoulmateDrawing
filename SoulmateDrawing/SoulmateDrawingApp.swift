//
//  SoulmateDrawingApp.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 17.12.2025.
//

import SwiftUI

@main
struct SoulmateDrawingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("kNeedShowOnboarding") var isShowOnboarding = true
    
    var body: some Scene {
        WindowGroup {
            if isShowOnboarding {
                OnboardingView()
            } else {
                RootView()
            }
        }
    }
}
