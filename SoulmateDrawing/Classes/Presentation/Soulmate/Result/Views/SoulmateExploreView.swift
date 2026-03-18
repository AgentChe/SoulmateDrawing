//
//  SoulmateExploreView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import SwiftUI

struct SoulmateExploreView: View {
    let title: String
    let items: [ExploreItem]
    let hasActiveSubscription: Bool
    let selected: (ExploreItem) -> Void
    let unfoldAction: () -> Void
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                .foregroundStyle(.textMain200)
            
            Text("Soulmate.Explore.Title".localized)
                .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                .foregroundStyle(.textMain200)
                .padding(.top, 32.scale)
            
            ForEach(items, id: \.self) { item in
                Button(
                    action: { selected(item) },
                    label: {
                        SoulmateExploreCardView(
                            item: item,
                            hasActiveSubscription: hasActiveSubscription,
                            unfoldAction: unfoldAction
                        )
                    }
                )
                .buttonStyle(.card)
                .itemShadow()
            }
            .padding(.top, 16.scale)
        }
    }
}
