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

extension ProgressViewStyle where Self == OnboardingProgressStyle {
    static var onboarding: Self { OnboardingProgressStyle() }
}
