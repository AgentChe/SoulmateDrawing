//
//  LoadingView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 17.12.2025.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Text("Soulmate\nDrawing")
                .font(Font.Gambarino.font(size: 32, weight: .w400))
                .foregroundStyle(Color.textMain200)
                .multilineTextAlignment(.center)
                .padding(.top, 60)
                .padding(.horizontal, 24)
            
            Spacer()
            
            ProgressView()
                .progressViewStyle(.spinner)
                .padding(.bottom, 65)
        }
        .frame(maxWidth: .infinity)
        .background {
            Image("Splash")
                .padding(.top, 189)
                .blendMode(.lighten)
        }
        .appBackground()
    }
}

struct SpinnerProgerssStyle: ProgressViewStyle {
    @State private var rotation: Double = 0
    private let animation = Animation.linear(duration: 0.75).repeatForever(autoreverses: false)
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .stroke(Color.bgMain400, lineWidth: 2)
            
            Circle()
                .trim(from: 0.35, to: 0.85)
                .stroke(Color.textMain200, style: .init(lineWidth: 2, lineCap: .round))
                .rotationEffect(.radians(-rotation))
                .animation(animation, value: rotation)
                .task { rotation = .pi * 2 }
        }
        .frame(width: 30, height: 30)
    }
}

extension ProgressViewStyle where Self == SpinnerProgerssStyle {
    static var spinner: Self { .init() }
}

#Preview {
    SplashView()
}
