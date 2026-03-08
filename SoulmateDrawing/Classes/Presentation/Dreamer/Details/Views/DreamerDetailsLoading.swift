//
//  DreamerDetailsLoading.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.03.2026.
//

import SwiftUI
import RiveRuntime

struct DreamerDetailsLoading: View {
    private let model = RiveViewModel(fileName: "dreamer", autoPlay: false)
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("Dreamer.Loading.Title".localized)
                .font(Font.Gambarino.font(size: 32, weight: .w400))
                .padding(.top, 24)
            
            Text("Dreamer.Loading.Subtitle".localized)
                .font(Font.SFPro.font(size: 17, weight: .w400))
            Spacer()
        }
        .foregroundStyle(.textMain200)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity)
        .background {
            ZStack {
                
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                model.view()
                    .ignoresSafeArea()
                    .opacity(0.4)
                    .blendMode(.overlay)
            }
            .compositingGroup()
        }
        .onAppear {
            model.play()
        }
    }
}

#Preview {
    NavigationStack {
        DreamerDetailsLoading()
    }
}
