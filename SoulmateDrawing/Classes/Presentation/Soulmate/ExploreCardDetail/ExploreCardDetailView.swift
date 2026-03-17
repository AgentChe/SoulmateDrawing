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
                    .padding(.top, 174.scale)
                
                Text(item.text)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 24.scale)
            .frame(maxWidth: .infinity)
        }
        .bluredNavigationBar()
        .background(alignment: .top) {
            LazyImage(source: item.image) { state in
                if let image = state.image {
                    image
                        .aspectRatio(1.09, contentMode: .fit)
                        .overlay(alignment: .top) {
                            let color = Color(red: 1, green: 240/255, blue: 223/255)
                            LinearGradient(
                                stops: [
                                    .init(color: color.opacity(0), location: 0.62),
                                    .init(color: color, location: 0.84)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                }
            }
            .ignoresSafeArea()
        }
        .background(.bgMain100)
        .customBackButton()
    }
}
