//
//  OnboardingView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(RootViewModel.self) private var rootManager
    @State private var viewModel = OnboardingViewModel()
    
    @State private var isStart = true
    
    var body: some View {
        ZStack {
            if !isStart {
                TabView(selection: $viewModel.currentOnboarding) {
                    ForEach(viewModel.onboardings, id: \.self) { element in
                        switch element {
                        case .name:
                            OnboardingNameView(name: viewModel.user.name) { saved in
                                viewModel.user.name = saved
                                viewModel.didTapContinue()
                            }
                        case .bornDate:
                            OnboardingBornDate(bornDate: viewModel.user.bornDate) {
                                viewModel.user.bornDate = $0
                                viewModel.didTapContinue()
                            }
                        case .bornTime:
                            OnboardingBornTime(bornTime: viewModel.user.bornDate) {
                                viewModel.user.bornDate = $0
                                viewModel.didTapContinue()
                            }
                        case .bornCity:
                            OnboardingCityView(city: viewModel.user.city) {
                                viewModel.user.city = $0.id
                                viewModel.didTapContinue()
                            }
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .transition(.move(edge: .trailing))
                .ignoresSafeArea()
            } else {
                OnboardingWelcomeScreen(
                    didTapContinue: {
                        withAnimation {
                            isStart = false
                        }
                    }
                )
            }
        }
        .overlay(alignment: .top, content: {
            ProgressView(value: viewModel.progress)
                .progressViewStyle(.onboarding)
                .padding(.top, 32.scale)
                .padding(.horizontal, 24.scale)
                .opacity(isStart ? 0 : 1)
        })
        .appBackground()
        .animation(.default, value: viewModel.currentOnboarding)
        .screenState(viewModel.screenState, tryAgain: viewModel.saveData)
        .onChange(of: viewModel.isFinish) { _, newValue in
            if newValue {
                rootManager.finishOnboarding()
            }
        }
    }
}

#Preview {
    OnboardingWelcomeScreen {}
}
