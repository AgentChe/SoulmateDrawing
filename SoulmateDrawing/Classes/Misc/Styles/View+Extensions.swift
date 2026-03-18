//
//  View+Extensions.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.03.2026.
//

import SwiftUI

struct BackgroundImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
    }
}

extension View {
    func appBackground() -> some View {
        modifier(BackgroundImageModifier())
    }
}

extension View {
    func itemShadow() -> some View {
        shadow(color: .clear, radius: 144)
            .shadow(color: Color.black.opacity(0.1), radius: 53, y: 21)
            .shadow(color: Color.white.opacity(0.04), radius: 42, y: 10)
            .shadow(color: Color.white.opacity(0.16), radius: 0, y: 1.34)
    }
}
