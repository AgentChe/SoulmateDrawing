//
//  SoulmateExploreCardView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import SwiftUI


struct SoulmateExploreCardView: View {
    let item: ExploreItem
    let unfoldAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if item.isLocked, let unlockLabel = item.unlockLabel {
                HStack(spacing: 4) {
                    Text(unlockLabel)
                        .font(Font.SFPro.font(size: 17, weight: .w400))
                        .foregroundStyle(.textMain200.opacity(0.8))
                    
                    Image("lock")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding(.bottom, 4)
            }
            Text(item.title)
                .font(Font.Gambarino.font(size: 22, weight: .w400))
                .foregroundStyle(.textMain200)
                .lineLimit(1)
                .padding(.bottom, 12)
            
            Text(item.text)
                .font(Font.SFPro.font(size: 17, weight: .w400))
                .foregroundStyle(.textMain200)
                .lineLimit(2)
                .overlay(alignment: .leading) {
                    if item.isLocked {
                        let color = Color(red: 1, green: 251/255, blue: 245/255)
                        LinearGradient(
                            stops: [
                                .init(color: color.opacity(0), location: 0.02),
                                .init(color: color.opacity(0.6), location: 0.12),
                                .init(color: color, location: 0.33)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
            
            if item.isLocked {
                Button(
                    action: unfoldAction,
                    label: {
                        Text("Soulmate.Unfold".localized)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                    }
                )
                .background(.bgMain300)
                .clipShape(Capsule())
                .foregroundStyle(.textMain200)
                .padding(.top, 12)
            }
        }
        .padding(24)
        .background(.bgMain200, in: RoundedRectangle(cornerRadius: 32))
        .compositingGroup()
    }
}
