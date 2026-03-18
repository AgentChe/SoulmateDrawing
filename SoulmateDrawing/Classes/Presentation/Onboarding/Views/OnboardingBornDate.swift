//
//  OnboardingBornDate.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.03.2026.
//

import SwiftUI

struct OnboardingBornDate: View {
    @State private var bornDate: Date
    var didTapContinue: (Date) -> Void
    
    init(bornDate: Date?, didTapContinue: @escaping (Date) -> Void) {
        self._bornDate = State(initialValue: bornDate ?? .init())
        self.didTapContinue = didTapContinue
    }
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 16.scale) {
                Text("Onboarding.Born.Title".localized)
                    .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                
                Text("Onboarding.Date.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .multilineTextAlignment(.center)
            .padding(.top, 74.scale)
            
            DatePicker("", selection: $bornDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.wheel)
                .padding(.top, 100.scale)
                .labelsHidden()
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
            
            Spacer()
            
            Button(
                action: {
                    didTapContinue(bornDate)
                },
                label: { Text("Continue") }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24.scale)
        }
        .padding(.horizontal, 24.scale)
        .frame(maxWidth: .infinity, alignment: .center)
        .appBackground()
    }
}

#Preview {
    OnboardingBornDate(bornDate: nil, didTapContinue: { _ in })
}
