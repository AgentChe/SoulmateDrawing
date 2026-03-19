//
//  OnboardingView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State var viewModel: OnboardingViewModel
    
    @State private var isStart = true
    
    var body: some View {
        ZStack {
            if !isStart {
                TabView(selection: $viewModel.currentOnboarding) {
                    ForEach(viewModel.onboardings, id: \.self) { element in
                        switch element {
                        case .name:
                            ZStack {
                                OnboardingNameView(name: viewModel.userName, isOnboarding: true) { saved in
                                    viewModel.userName = saved
                                    viewModel.didTapContinue()
                                }
                            }
                        case .bornDate:
                            ChooseBornDateView(bornDate: viewModel.bornDate, isOnboarding: true) {
                                viewModel.bornDate = $0
                                viewModel.didTapContinue()
                            }
                        case .bornTime:
                            ChooseBornTimeView(bornTime: viewModel.bornTime, isOnboarding: true) {
                                viewModel.bornTime = $0
                                viewModel.didTapContinue()
                            }
                        case .bornCity:
                            ChooseCityView(city: viewModel.city, isOnboarding: true) {
                                viewModel.city = $0.id
                                viewModel.didTapContinue()
                            }
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .transition(.move(edge: .trailing))
                .ignoresSafeArea(viewModel.currentOnboarding == .bornCity ? [] : .keyboard)
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
                .padding(.horizontal, 24.scale)
                .opacity(isStart ? 0 : 1)
        })
        .appBackground()
        .animation(.default, value: viewModel.currentOnboarding)
        .screenState(viewModel.screenState)
    }
}

#Preview {
    OnboardingWelcomeScreen {}
}
