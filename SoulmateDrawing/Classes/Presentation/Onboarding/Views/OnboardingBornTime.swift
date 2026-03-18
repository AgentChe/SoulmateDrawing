//
//  OnboardingBornTime.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.03.2026.
//

import SwiftUI

struct OnboardingBornTime: View {
    @State private var bornTime: Date
    var didTapContinue: (Date) -> Void
    
    init(bornTime: Date?, didTapContinue: @escaping (Date) -> Void) {
        self._bornTime = .init(wrappedValue: bornTime ?? .init())
        self.didTapContinue = didTapContinue
    }
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 16.scale) {
                Text("Onboarding.Born.Title".localized)
                    .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                
                Text("Onboarding.Time.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .multilineTextAlignment(.center)
            .padding(.top, 74.scale)
            .padding(.horizontal, 24.scale)
            
            DatePicker("", selection: $bornTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .padding(.horizontal, 24.scale)
                .padding(.top, 100.scale)
                .labelsHidden()
            
            Spacer()
            
            Button(
                action: {
                    didTapContinue(bornTime)
                },
                label: { Text("Continue") }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24.scale)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .appBackground()
    }
}
