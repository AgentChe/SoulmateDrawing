//
//  SettingsItemView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import SwiftUI

struct SettingsItemView: View {
    typealias Item = ProfileSection.Model
    
    let item: Item
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                HStack {
                    Text(item.title)
                        .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                        .foregroundStyle(.textMain200)
                    Spacer()
                    
                    if let value = item.value {
                        HStack(spacing: 8.scale) {
                            Text(value)
                                .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                                .foregroundStyle(.textMain200.opacity(0.5))
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.textMain200)
                        }
                    }
                }
            }
        )
    }
}
