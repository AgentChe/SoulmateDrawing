//
//  HeaderBlur.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 17.03.2026.
//

import SwiftUI

struct HeaderBlur: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content
        } else {
            content
                .mask {
                    Color.black
                        .overlay(alignment: .top) {
                            LinearGradient(colors: [.black.opacity(0.75), .black.opacity(0.25), .black.opacity(0)], startPoint: .bottom, endPoint: .top)
                        }
                        .blur(radius: 20)
                }
                .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

extension View {
    func bluredNavigationBar() -> some View {
        modifier(HeaderBlur())
    }
}
