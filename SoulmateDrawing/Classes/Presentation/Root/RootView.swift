//
//  RootView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 17.12.2025.
//

import SwiftUI

struct RootView: View {
    @State private var viewModel = RootViewModel()
    
    var body: some View {
        ZStack {
            switch viewModel.currentRoute {
            case .splash:
                SplashView()
                    .task { viewModel.makeInitialize() }
                    .screenState(viewModel.screenState, tryAgain: viewModel.login)
                    .transition(.opacity)
            case .onboarding:
                OnboardingView()
                    .environment(viewModel)
            case .main:
                MainView()
                    .transition(.opacity)
            }
        }
        .background(.black)
        .animation(.easeOut, value: viewModel.currentRoute)
        .preferredColorScheme(.light)
    }
}

#Preview {
    RootView()
}
