//
//  BondsInsightCard.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import SwiftUI

struct BondsInsightCard: View {
    let model: InsightModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(model.formattedDate)
                .opacity(0.8)
                .padding(.bottom, 4.scale)
            
            Text(model.text)
                .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 24.scale)
            
            HStack(spacing: 4.scale) {
                Text(model.pairText)
                Text(model.connectionType.title)
                    .padding(.horizontal, 12.scale)
                    .padding(.vertical, 6.scale)
                    .background(.bgMain300, in: Capsule())
            }
            .font(Font.SFPro.font(size: 17.scale, weight: .w510))
        }
        .foregroundStyle(.textMain200)
        .padding(24.scale)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.bgMain200)
        .clipShape(RoundedRectangle(cornerRadius: 32.scale))
    }
}
