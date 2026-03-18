//
//  SoulmateProfileView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import SwiftUI

struct SoulmateProfileView: View {
    @Bindable var viewModel: SoulmateCheckProfileViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12.scale) {
                Text("Soulmate.Profile.Title".localized)
                    .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                Text("Soulmate.Profile.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16.scale)
            
            ProfileView(
                name: viewModel.profileName,
                sign: viewModel.sign,
                mainPoints: viewModel.mainPoints
            )
            .padding(.top, 40.scale)
            
            Spacer()
            
            ForEach(viewModel.profileInfo) {
                SoulmateCheckProfileValueView(title: $0.title, value: $0.value)
            }
            
            Spacer()
            
            Button(
                action: viewModel.didTapContinue,
                label: {
                    Text("Soulmate.Profile.Continue".localized)
                }
            )
            .buttonStyle(.primary)
            
            Button(
                action: viewModel.openSettings,
                label: {
                    Text("Soulmate.Profile.Edit".localized)
                }
            )
            .buttonStyle(.secondary)
            .padding(.top, 16.scale)
        }
        .frame(maxWidth: .infinity)
        .screenState(viewModel.screenState)
    }
}
