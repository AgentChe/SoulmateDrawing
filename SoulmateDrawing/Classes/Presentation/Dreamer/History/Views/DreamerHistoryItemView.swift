//
//  DreamerHistoryItemView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 12.03.2026.
//

import SwiftUI
import NukeUI

struct DreamerHistoryItemView: View {
    let item: DreamHistoryItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.scale) {
            Text(item.date)
                .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                .foregroundStyle(.textMain200.opacity(0.8))
            
            HStack(spacing: 0) {
                Text(item.text)
                    .lineLimit(2)
                    .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
                Spacer(minLength: 24.scale)
                
                LazyImage(source: item.image) { state in
                    if let image = state.image {
                        image
                    } else {
                        Color.clear
                    }
                }
                .frame(width: 45.scale, height: 50.scale)
                .clipShape(Circle())
            }
        }
        .padding(24.scale)
        .background(.bgMain200, in: RoundedRectangle(cornerRadius: 32.scale))
    }
}
