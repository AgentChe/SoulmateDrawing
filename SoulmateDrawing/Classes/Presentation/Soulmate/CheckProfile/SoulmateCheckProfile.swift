//
//  SoulmateCheckProfile.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 28.01.2026.
//

import SwiftUI

struct SoulmateProfileView: View {
//    @Environment(\.navigation) private var navigation
    
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

struct SoulmateGenerateView: View {
    @Bindable var viewModel: SoulmateCheckProfileViewModel
    var body: some View {
        VStack(spacing: 0) {
            Text("Soulmate.Generate.Title".localized)
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.bottom, 12.scale)
            
            Text("Soulmate.Generate.Subtitle".localized)
                .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40.scale)
            
            RoundedRectangle(cornerRadius: 32.scale)
                .fill(Color(red: 1, green: 251/255, blue: 245/255))
                .aspectRatio(0.98, contentMode: .fit)
                .overlay {
                    ZStack {
                        Image("SoulmatePlaceholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .blur(radius: 20)
                        
                        ProgressView()
                            .progressViewStyle(.spinner)
                    }
                    .padding(26.scale)
                }
                .clipShape(RoundedRectangle(cornerRadius: 32.scale))
        }
        .screenState(viewModel.screenState)
    }
}

struct SoulmateCheckProfile: View {
//    @Environment(\.dismiss) private var dismiss
//    @Environment(\.navigation) private var navigation
    
    @State var viewModel: SoulmateCheckProfileViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isGenerateSoulmate {
                SoulmateGenerateView(viewModel: viewModel)
                    .transition(.move(edge: .leading))
            } else {
                SoulmateProfileView(viewModel: viewModel)
                    .transition(.move(edge: .leading))
            }
        }
        .padding(.horizontal, 24.scale)
        .frame(maxWidth: .infinity)
        .appBackground()
        .closeButton(action: viewModel.close)
//        .sheet(item: $viewModel.sheetType) { type in
//            switch type {
//            case .ethnicity(let items):
//                SoulmatePreferencesView(elements: items) {
//                    viewModel.didSelect(ethnicity: $0)
//                }
//                .presentationDragIndicator(.visible)
//                .presentationCornerRadius(32.scale)
//            case .gender(let items):
//                SoulmatePreferencesView(elements: items) {
//                    viewModel.didSelect(gender: $0)
//                }
//                .presentationDragIndicator(.visible)
//                .presentationCornerRadius(32.scale)
//            }
//        }
//        .fullScreenCover(item: $viewModel.fullScreen) { item in
//            switch item {
//            case .settings:
//                NavigationStack {
//                    SettingsView()
//                }
//            }
//        }
//        .onChange(of: viewModel.push) { _, newValue in
//            guard let newValue else { return }
//            switch newValue {
//            case let .soulmateResult(model):
//                dismiss()
//                navigation.push(.soulmateResult(model))
//            }
//            
//        }
    }
}
