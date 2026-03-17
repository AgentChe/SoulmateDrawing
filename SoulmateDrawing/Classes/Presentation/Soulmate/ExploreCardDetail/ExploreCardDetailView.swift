//
//  ExploreCardDetailView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import SwiftUI
import NukeUI

struct ExploreCardDetailView: View {
    let item: ExploreItem
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 24.scale) {
                Text(item.title)
                    .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
                    .padding(.top, 284.scale)
                
                Text(item.text)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 34.scale)
            }
            .padding(.horizontal, 24.scale)
            .frame(maxWidth: .infinity)
            .background(alignment: .top) {
                LazyImage(source: item.image) { state in
                    if let image = state.image {
                        image.aspectRatio(1.09, contentMode: .fit)
                    } else {
                        Color.clear
                    }
                }
                .headerViewMask()
            }
        }
        .background(.bgMain100)
        .customBackButton()
        .toolbarBackground(.hidden, for: .navigationBar)
        .ignoresSafeArea()
    }
}

extension View {
    func headerViewMask() -> some View {
        let color = Color(red: 1, green: 240/255, blue: 223/255)
        return overlay(alignment: .bottom) {
            LinearGradient(
                stops: [
                    .init(color: color.opacity(0), location: 0.62),
                    .init(color: color, location: 0.84)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .mask {
            Color.white.opacity(0.2)
                .overlay {
                    GeometryReader { proxy in
                        let radius = proxy.size.width / 2
                        RadialGradient(
                            stops: [
                                .init(color: color, location: 0.67),
                                .init(color: color.opacity(0), location: 1)
                            ],
                            center: .center,
                            startRadius: radius * 0.7,
                            endRadius: radius * 0.75
                        )
                    }
                }
            
            .blur(radius: 20)
        }
    }
}
