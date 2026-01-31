//
//  SoulmateOnboarding.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 22.01.2026.
//

import SwiftUI
import RiveRuntime

struct SoulmateOnboarding: View {
    @State private var isAppear = false
    let model = RiveViewModel(fileName: "drawing", autoPlay: false)
    var body: some View {
        VStack {
            VStack(spacing: 12) {
                Text("Soulmate.Onboarding.Title".localized)
                    .font(Font.Gambarino.font(size: 32, weight: .w400))
                Text("Soulmate.Onboarding.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            .padding(.top, 10)
            .offset(y: isAppear ? 0 : 40)
            .opacity(isAppear ? 1 : 0)
            .animation(.spring().speed(0.5), value: isAppear)
            
            Spacer()
            
            Button(
                action: {
                },
                label: {
                    Text("Soulmate.Onboarding.Button".localized)
                }
            )
            .buttonStyle(.primary)
            .padding(.horizontal, 24)
            .offset(y: isAppear ? 0 : 20)
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
        .toolbar {
            ToolbarButton(placement: .topBarTrailing) {
                Button(
                    action: {},
                    label: { Image(systemName: "xmark") }
                )
                .foregroundStyle(.textMain200)
                .buttonStyle(.navigation)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SoulmateOnboarding()
    }
}
