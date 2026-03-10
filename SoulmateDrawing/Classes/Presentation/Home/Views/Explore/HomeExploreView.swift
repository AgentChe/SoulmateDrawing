//
//  HomeExploreView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import SwiftUI

struct HomeExploreView: View {
    let selected: (ExploreType) -> Void
    let exploreCards: [ExploreType] = [.soulmate, .dream, .relationship]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12.scale) {
                Text("Home.Explore.Title".localized)
                    .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                
                Text("Home.Explore.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40.scale)
            
            GeometryReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 26.scale) {
                        ForEach(exploreCards, id: \.self) { card in
                            Button(
                                action: { selected(card) },
                                label: {
                                    ExploreCardView(card: card)
                                }
                            )
                            .buttonStyle(.card)
                            .itemShadow()
                            .visualEffect { content, proxy in
                                let progress = (proxy.bounds(of: .scrollView)?.minX ?? 0) / proxy.size.width
                                
                                let yOffset = progress < 0 ? progress * -50 : progress * 50
                                let angle = progress * -6
                                
                                return content
                                    .offset(y: yOffset)
                                    .rotationEffect(.degrees(angle))
                            }
                        }
                    }
                    .frame(height: proxy.size.height)
                    .offset(y: -35)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, (proxy.size.width - 200) / 2)
                .frame(height: proxy.size.height)
            }
            .frame(height: 320)
            .scrollClipDisabled()
            .padding(.top, 32)
        }
    }
}

#Preview {
    NavigationStack {
        HomeExploreView { _ in}
    }
    .appBackground()
}
