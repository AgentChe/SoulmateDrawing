//
//  OnboardingNameView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.03.2026.
//

import SwiftUI

struct OnboardingNameView: View {
    @State private var name: String
    private let isOnboarding: Bool
    private var didTapContinue: (String) -> Void
    
    init(name: String, isOnboarding: Bool, didTapContinue: @escaping (String) -> Void) {
        self._name = State(initialValue: name)
        self.isOnboarding = isOnboarding
        self.didTapContinue = didTapContinue
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Onboarding.Name.Title".localized)
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.top, isOnboarding ? 32.scale : 60.scale)
            
            TextField(text: $name) {
                Text("Onboarding.Name.Placeholder".localized)
                    .font(.system(size: 23.scale, weight: .regular))
                    .foregroundStyle(.textMain200.opacity(0.6))
            }
            .padding(.top, 118.scale)
            .multilineTextAlignment(.center)
            .foregroundStyle(.textMain200)
            
            Spacer()
            
            Button(
                action: {
                    didTapContinue(name)
                },
                label: { Text("Continue") }
            )
            .buttonStyle(.primary)
            .disabled(name.isEmpty)
        }
        .padding(.horizontal, 24.scale)
        .frame(maxWidth: .infinity, alignment: .center)
        .appBackground()
    }
}
