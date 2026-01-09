//
//  HomeExploreView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import SwiftUI

struct HomeExploreView: View {
    let exploreCards: [ExploreType] = [.soulmate, .dream, .relationship]
    
    var body: some View {
        LazyVStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("Home.Explore.Title".localized)
                    .font(Font.Gambarino.font(size: 32, weight: .w400))
                
                Text("Home.Explore.Subtitle".localized)
                    .font(Font.SFPro.font(size: 17, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(exploreCards, id: \.self) { card in
                        ExploreCardView(card: card)
                            .scrollTransition { view, transition in
                                view
//                                    .rotationEffect(.radians(transition.value))
                            }
//                            .visualEffect { content, proxy in
//                                let angleStep = (Angle.degrees(360).radians / Double(3))
//                                let index = exploreCards.firstIndex(of: card) ?? 0
//
//                                let angle = angleStep * Double(index) + Angle.degrees(90).radians
//                                var point = CGPoint(x: 0, y: -50).applying(CGAffineTransform(rotationAngle: angle))
//
//                                return content
//                                    .offset(x: point.x, y: point.y)
//                            }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, 200)
            .scrollClipDisabled()
            .scrollTargetBehavior(.paging)
            .defaultScrollAnchor(.center)
            .padding(.top, 32)
        }
    }
}

#Preview {
    HomeExploreView()
}
