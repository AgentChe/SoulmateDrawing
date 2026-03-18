//
//  ChatRetryView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.03.2026.
//

import SwiftUI

struct ChatRetryView: View {
    let action: () -> Void
    var body: some View {
        VStack(spacing: 12) {
            Button(action: action) {
                Text("Chat.RetryButton".localized)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w510))
                    .padding(.vertical, 10.scale)
                    .padding(.horizontal, 12.scale)
            }
            .foregroundStyle(.textMain200)
            .background(.bgMain300)
            .clipShape(Capsule())
            
            Text("Chat.RetryMessage".localized)
                .font(Font.SFPro.font(size: 15.scale, weight: .w400))
                .foregroundStyle(.textMain200.opacity(0.6))
        }
    }
}

#Preview {
    ChatRetryView {}
}
