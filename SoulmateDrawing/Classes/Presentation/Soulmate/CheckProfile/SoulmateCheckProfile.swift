//
//  SoulmateCheckProfile.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 28.01.2026.
//

import SwiftUI

private extension SoulmateCheckProfile {
    enum SheetType: Identifiable {
        case settings
        
        var id: Self { self }
    }
}

struct SoulmateCheckProfile: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = SoulmateCheckProfileViewModel()
    @State private var sheetType: SheetType? = nil
    @State var isShow = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("Soulmate.Profile.Title".localized)
                    .font(Font.Gambarino.font(size: 32, weight: .w400))
                Text("Soulmate.Profile.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            
            Spacer()
            
            ProfileView(
                name: viewModel.profileName,
                zodiac: .aries,
                mainPoints: viewModel.mainPoints
            )
            .padding(.top, 40)
            
            Spacer()
            
            ForEach(viewModel.profileInfo) {
                SoulmateCheckProfileValueView(title: $0.title, value: $0.value)
            }
            
            Spacer()
            
            Button(
                action: {},
                label: {
                    Text("Soulmate.Profile.Continue".localized)
                }
            )
            .buttonStyle(.primary)
            
            Button(
                action: { isShow = true },
                label: {
                    Text("Soulmate.Profile.Edit".localized)
                }
            )
            .buttonStyle(.secondary)
            .padding(.top, 16)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .appBackground()
        .toolbar {
            ToolbarButton(placement: .topBarTrailing) {
                Button(
                    action: dismiss.callAsFunction,
                    label: { Image(systemName: "xmark") }
                )
                .foregroundStyle(.textMain200)
                .buttonStyle(.navigation)
            }
        }
        .screenState(viewModel.screenState) {
            viewModel.load()
        }
        .sheet(item: $sheetType) { type in
            switch type {
            case .settings:
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .fullScreenCover(isPresented: $isShow) {
            NavigationStack {
                SettingsView()
            }
        }
    }
}

#Preview {
    @Previewable @State var isShow = false
    NavigationStack {
        Color.red
            .overlay {
                Button(action: { isShow = true }, label: { Text("TAP ME ")})
            }
        
    }
    .fullScreenCover(isPresented: $isShow) {
        NavigationStack {
            SoulmateCheckProfile()
        }
    }
}
