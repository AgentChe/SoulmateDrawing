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
                                viewModel.user.city = $0
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
                .padding(.top, 32)
                .padding(.horizontal, 24)
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

struct OnboardingWelcomeScreen: View {
    var didTapContinue: () -> Void
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Text("Onboarding.Welcom.Title".localized)
                    .font(Font.Gambarino.font(size: 32, weight: .w400))
                
                Text("Onboarding.Welcom.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .multilineTextAlignment(.center)
            .padding(.top, 74)
            
            Spacer()
            
            Button(
                action: didTapContinue,
                label: { Text("Continue") }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
    }
}

struct OnboardingNameView: View {
    var didTapContinue: (String) -> Void
    @State private var name: String
    
    init(name: String, didTapContinue: @escaping (String) -> Void) {
        self._name = State(initialValue: name)
        self.didTapContinue = didTapContinue
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Onboarding.Name.Title".localized)
                .font(Font.Gambarino.font(size: 32, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.top, 74)
            
            TextField(text: $name) {
                Text("Onboarding.Name.Placeholder".localized)
                    .font(.system(size: 23, weight: .regular))
            }
            .padding(.top, 118)
            .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(
                action: {
                    didTapContinue(name)
                },
                label: { Text("Continue") }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct OnboardingBornDate: View {
    @State private var bornDate: Date
    var didTapContinue: (Date) -> Void
    
    init(bornDate: Date?, didTapContinue: @escaping (Date) -> Void) {
        self._bornDate = State(initialValue: bornDate ?? .init())
        self.didTapContinue = didTapContinue
    }
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 16) {
                Text("Onboarding.Born.Title".localized)
                    .font(Font.Gambarino.font(size: 32, weight: .w400))
                
                Text("Onboarding.Date.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .multilineTextAlignment(.center)
            .padding(.top, 74)
            
            DatePicker("", selection: $bornDate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .padding(.top, 100)
                .labelsHidden()
                .font(Font.Gambarino.font(size: 32, weight: .w400))
            
            Spacer()
            
            Button(
                action: {
                    didTapContinue(bornDate)
                },
                label: { Text("Continue") }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct OnboardingBornTime: View {
    @State private var bornTime: Date
    var didTapContinue: (Date) -> Void
    
    init(bornTime: Date?, didTapContinue: @escaping (Date) -> Void) {
        self._bornTime = .init(initialValue: bornTime ?? .init())
        self.didTapContinue = didTapContinue
    }
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 16) {
                Text("Onboarding.Born.Title".localized)
                    .font(Font.Gambarino.font(size: 32, weight: .w400))
                
                Text("Onboarding.Time.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .multilineTextAlignment(.center)
            .padding(.top, 74)
            .padding(.horizontal, 24)
            
            DatePicker("", selection: $bornTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .padding(.horizontal, 24)
                .padding(.top, 100)
                .labelsHidden()
            
            Spacer()
            
            Button(
                action: {
                    didTapContinue(bornTime)
                },
                label: { Text("Continue") }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct OnboardingCityView: View {
    @State private var city: String
    var didTapContinue: (String) -> Void
    
    init(city: String, didTapContinue: @escaping (String) -> Void) {
        self._city = State(initialValue: city)
        self.didTapContinue = didTapContinue
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Onboarding.Born.Title".localized)
                .font(Font.Gambarino.font(size: 32, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.top, 74)
            
            TextField(text: $city) {
                Text("Onboarding.City.Placeholder".localized)
                    .font(.system(size: 23, weight: .regular))
            }
            .padding(.top, 118)
            .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(
                action: {
                    didTapContinue(city)
                },
                label: { Text("Continue") }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    OnboardingView()
        .environment(RootViewModel())
}
