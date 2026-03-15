//
//  ChatMessageView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 14.03.2026.
//

import SwiftUI

struct ChatMessageView: View {
    let model: ChatMessageModel
    
    var body: some View {
        switch model.role {
        case .user:
            HStack {
                Spacer(minLength: 72.scale)
                Text(model.content)
                    .padding(.horizontal, 20.scale)
                    .padding(.vertical, 16.scale)
                    .background(.bgMain400, in: RoundedRectangle(cornerRadius: 32.scale))
            }
            .transition(.opacity)
        case .assistant:
            HStack {
                if let attrs = try? AttributedString(markdown: model.content) {
                    Text(attrs)
                } else {
                    Text(model.content)
                }
                
                Spacer(minLength: 46.scale)
            }
            .transition(.opacity)
        }
    }
}
