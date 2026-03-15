//
//  OnboardingNameView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.03.2026.
//

import SwiftUI

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
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.top, 74.scale)
            
            TextField(text: $name) {
                Text("Onboarding.Name.Placeholder".localized)
                    .font(.system(size: 23.scale, weight: .regular))
            }
            .padding(.top, 118.scale)
            .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(
                action: {
                    didTapContinue(name)
                },
                label: { Text("Continue") }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24.scale)
            .disabled(name.isEmpty)
        }
        .padding(.horizontal, 24.scale)
        .frame(maxWidth: .infinity, alignment: .center)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    OnboardingNameView(name: "", didTapContinue: { _ in })
}
