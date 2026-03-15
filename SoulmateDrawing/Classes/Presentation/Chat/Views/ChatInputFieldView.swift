//
//  ChatInputFieldView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 14.03.2026.
//

import SwiftUI

struct ChatInputFieldView: View {
    @Binding var currentText: String
    var isFocused: FocusState<Bool>.Binding
    let action: () -> Void
    
    var body: some View {
        HStack {
            TextField(text: $currentText, axis: .vertical) {
                Text("Chat.Placeholder".localized)
                    .foregroundStyle(.textMain200.opacity(0.6))
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                   
            }
            .foregroundStyle(.textMain200)
            .focused(isFocused)
            
            if !currentText.isEmpty {
                Button(
                    action: {
                        withAnimation {
                            action()
                        }
                    },
                    label: {
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 32.scale, height: 32.scale)
                    }
                )
                .symbolVariant(.circle.fill)
                .foregroundStyle(.textMain100, .accentMain100)
                
            }
        }
        .padding(.vertical, 16.scale)
        .padding(.horizontal, 24.scale)
        .background(.bgMain300, in: RoundedRectangle(cornerRadius: 32.scale))
        .padding(.horizontal, 24.scale)
        .padding(.bottom, 16.scale)
    }
}
