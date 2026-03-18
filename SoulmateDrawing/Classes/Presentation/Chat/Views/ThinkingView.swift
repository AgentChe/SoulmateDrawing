//
//  ThinkingView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.03.2026.
//

import SwiftUI

struct ThinkingView: View {
    var body: some View {
        HStack(spacing: 0) {
            WaveLoader()
            Spacer()
        }
    }
}

struct WaveLoader: View {
    @State private var animating = false
    let numberOfDots = 3
    let dotSize: CGFloat = 4
    let spacing: CGFloat = 4

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<numberOfDots, id: \.self) { index in
                Circle()
                    .fill(.bgMain300)
                    .frame(width: 10.scale)
                    .offset(y: animating ? 4.scale : 0)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(index) * 0.3),
                        value: animating
                    )
            }
        }
        .onAppear {
            animating = true
        }
    }
}

#Preview {
    ThinkingView()
}
