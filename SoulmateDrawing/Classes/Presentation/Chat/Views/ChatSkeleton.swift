//
//  ChatSkeleton.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.03.2026.
//

import SwiftUI

struct ChatSkeleton: View {
    var body: some View {
        VStack(spacing: 12.scale) {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 4.scale)
                    .fill(.bgMain300)
                Spacer(minLength: 88.scale)
            }
            .frame(height: 12.scale)
            
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 4.scale)
                    .fill(.bgMain300)
                Spacer(minLength: 128.scale)
            }
            .frame(height: 12.scale)
            
            Spacer()
            
            ForEach(1...3, id: \.self) { _ in
                HStack {
                    Spacer(minLength: 96.scale)
                    RoundedRectangle(cornerRadius: 32.scale)
                        .fill(.bgMain400)
                }
                .frame(height: 80.scale)
            }
        }
    }
}

#Preview {
    ChatSkeleton()
        .appBackground()
}
