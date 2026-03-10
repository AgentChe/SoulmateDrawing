//
//  SoulmateOnboarding.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 22.01.2026.
//

import SwiftUI
import RiveRuntime

struct SoulmateOnboarding: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.navigation) private var navigation
    
    @State private var isAppear = false
    private let model = RiveViewModel(fileName: "drawing", autoPlay: false)
    
    var body: some View {
        VStack {
            VStack(spacing: 12.scale) {
                Text("Soulmate.Onboarding.Title".localized)
                    .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                Text("Soulmate.Onboarding.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40.scale)
            .padding(.top, 10.scale)
            .offset(y: isAppear ? 0 : 40.scale)
            .opacity(isAppear ? 1 : 0)
            .animation(.spring().speed(0.5), value: isAppear)
            
            Spacer()
            
            Button(
                action: {
                    dismiss()
                    navigation.fullScreen(.soulmateCheckProfile)
                },
                label: {
                    Text("Soulmate.Onboarding.Button".localized)
                }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24.scale)
            .offset(y: isAppear ? 0 : 20.scale)
            .opacity(isAppear ? 1 : 0)
            .animation(.spring().speed(0.5).delay(0.5), value: isAppear)
        }
        .frame(maxWidth: .infinity)
        .background {
            model.view()
                .ignoresSafeArea()
        }
        .onAppear {
            model.play()
        }
        .task {
            Task {
                try? await Task.sleep(for: .seconds(0.8))
                await MainActor.run {
                    isAppear = true
                }
            }
        }
        .closeButton(action: dismiss.callAsFunction)
    }
}

#Preview {
    NavigationStack {
        SoulmateOnboarding()
    }
}
