//
//  ProgressView+Styles.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.12.2025.
//

import SwiftUI

struct OnboardingProgressStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        Capsule()
            .fill(.bgMain300)
            .frame(height: 10)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                ProgressPath(progress: configuration.fractionCompleted ?? 0)
                    .fill(progressGradient)
            }
    }
    
    private var progressGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: Color(red: 235/255, green: 77/255, blue: 197/255), location: 0),
                .init(color: Color(red: 242/255, green: 165/255, blue: 182/255), location: 0.26),
                .init(color: Color(red: 237/255, green: 116/255, blue: 124/255), location: 0.57),
                .init(color: Color(red: 235/255, green: 73/255, blue: 201/255), location: 1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

struct ProgressPath: Shape {
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    var progress: Double
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let newRect = CGRect(
                origin: rect.origin,
                size: .init(width: rect.width * progress, height: rect.height)
            )
            
            path.addRoundedRect(in: newRect, cornerSize: .init(width: newRect.height, height: newRect.height))
        }
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

extension ProgressViewStyle where Self == OnboardingProgressStyle {
    static var onboarding: Self { OnboardingProgressStyle() }
}


extension ProgressViewStyle where Self == SpinnerProgerssStyle {
    static var spinner: Self { .init() }
}
