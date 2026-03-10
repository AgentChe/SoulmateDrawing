//
//  ExploreCardView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import SwiftUI

struct ExploreCardView: View {
    let card: ExploreType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(card.text)
                .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                .lineSpacing(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .horizontal], 24.scale)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.textMain200)
            Spacer()
        }
        .overlay(alignment: .bottom) {
            Image(card.imageName)
        }
        .frame(width: 200.scale, height: 250.scale)
        .background(.bgMain200)
        .clipShape(RoundedRectangle(cornerRadius: 32.scale))
    }
}
