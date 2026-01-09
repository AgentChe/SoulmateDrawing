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
    
    var body: some View {
        TabView(selection: $viewModel.currentOnboarding) {
            ForEach(viewModel.onboardings, id: \.self) { element in
                switch element {
                case .welcome:
                    OnboardingWelcomeScreen()
                case .name:
                    OnboardingNameView(user: $viewModel.user)
                case .bornDate:
                    OnboardingBornDate(user: $viewModel.user)
                case .bornTime:
                    OnboardingBornTime(user: $viewModel.user)
                case .bornCity:
                    OnboardingCityView(user: $viewModel.user)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .overlay(alignment: .bottom) {
            Button(
                action: viewModel.didTapContinue,
                label: { Text("Continue") }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24)
        }
        .overlay(alignment: .top, content: {
            ProgressView(value: viewModel.progress)
                .progressViewStyle(.onboarding)
                .padding(.top, 32)
                .padding(.horizontal, 24)
                .opacity(viewModel.currentOnboarding == .welcome ? 0 : 1)
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
            
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
    }
}

struct OnboardingNameView: View {
    @Binding var user: UserModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Onboarding.Name.Title".localized)
                .font(Font.Gambarino.font(size: 32, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.top, 74)
            
            TextField(text: $user.name) {
                Text("Onboarding.Name.Placeholder".localized)
                    .font(.system(size: 23, weight: .regular))
            }
            .padding(.top, 118)
            .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct OnboardingBornDate: View {
    @Binding var user: UserModel
    
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
            
            DatePicker("", selection: $user.bornDate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .padding(.top, 100)
                .labelsHidden()
                .font(Font.Gambarino.font(size: 32, weight: .w400))
            
            Spacer()
            
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct OnboardingBornTime: View {
    @Binding var user: UserModel
    
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
            
            DatePicker("", selection: $user.bornDate, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .padding(.horizontal, 24)
                .padding(.top, 100)
                .labelsHidden()
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct OnboardingCityView: View {
    @Binding var user: UserModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Onboarding.Born.Title".localized)
                .font(Font.Gambarino.font(size: 32, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.top, 74)
            
            TextField(text: $user.city) {
                Text("Onboarding.City.Placeholder".localized)
                    .font(.system(size: 23, weight: .regular))
            }
            .padding(.top, 118)
            .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    OnboardingView()
}
