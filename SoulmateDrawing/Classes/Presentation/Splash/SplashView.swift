//
//  LoadingView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 17.12.2025.
//

import SwiftUI
import RiveRuntime

struct SplashView: View {
    private let model = RiveViewModel(fileName: "splash_screen", autoPlay: true)
    
    var body: some View {
        VStack {
            Spacer()
            
            ProgressView()
                .progressViewStyle(.spinner)
                .padding(.bottom, 65.scale)
        }
        .frame(maxWidth: .infinity)
        .background {
            model.view()
                .ignoresSafeArea()
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
        .frame(width: 30.scale, height: 30.scale)
    }
}

extension ProgressViewStyle where Self == SpinnerProgerssStyle {
    static var spinner: Self { .init() }
}

#Preview {
    SplashView()
}
