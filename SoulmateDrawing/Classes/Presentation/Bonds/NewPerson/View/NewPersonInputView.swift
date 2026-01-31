//
//  NewPersonInputView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.01.2026.
//

import SwiftUI

struct NewPersonInputView: View {
    let text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(placeholder)
                .font(Font.SFPro.font(size: text.isEmpty ? 17 : 14, weight: .w400))
                .foregroundStyle(.textMain200)
                .opacity(0.3)
            if !text.isEmpty {
                Text(text)
                    .font(Font.SFPro.font(size: 17, weight: .w400))
                    .foregroundStyle(.textMain200)
                    .lineLimit(1)
            }
        }
        .padding(.init(
            top: text.isEmpty ? 16 : 6,
            leading: 16,
            bottom: text.isEmpty ? 16 : 9,
            trailing: 16
        ))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.bgMain300, in: RoundedRectangle(cornerRadius: 16))
    }
}
