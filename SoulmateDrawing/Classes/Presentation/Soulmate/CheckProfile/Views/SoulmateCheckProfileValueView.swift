//
//  SoulmateCheckProfileValueView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 29.01.2026.
//

import SwiftUI

struct SoulmateCheckProfileValueView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(Font.SFPro.font(size: 17, weight: .w400))
                .foregroundStyle(.textMain200)
            Spacer()
            Text(value)
                .font(Font.SFPro.font(size: 17, weight: .w400))
                .foregroundStyle(.textMain200.opacity(0.5))
        }
        .padding(.vertical, 16)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.bgMain300)
                .frame(height: 1.5)
        }
    }
}

