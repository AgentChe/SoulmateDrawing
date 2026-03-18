//
//  OnboardingWelcomeScreen.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.03.2026.
//

import SwiftUI
import RiveRuntime

struct OnboardingWelcomeScreen: View {
    private let model = RiveViewModel(fileName: "welcome_soulmate_drawing", autoPlay: true)
    
    var didTapContinue: () -> Void
    
    var body: some View {
        VStack {
            VStack(spacing: 16.scale) {
                Text("Onboarding.Welcom.Title".localized)
                    .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                
                Text("Onboarding.Welcom.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .multilineTextAlignment(.center)
            .padding(.top, 74.scale)
            
            Spacer()
            
            Button(
                action: didTapContinue,
                label: { Text("Continue") }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24.scale)
        }
        .padding(.horizontal, 24.scale)
        .frame(maxWidth: .infinity)
        .background(alignment: .bottom) {
            model.view()
                .ignoresSafeArea()
        }
        .appBackground()
    }
}

#Preview {
    OnboardingWelcomeScreen {}
}
