//
//  DreamerMainScreen.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.02.2026.
//

import SwiftUI

struct DreamerMainScreen: View {
    @State private var text: String = ""
    var body: some View {
        VStack(spacing: 24) {
            TextField("Dreamer.Placeholder".localized, text: $text, axis: .vertical)
                .frame(maxHeight: 300, alignment: .top)
                .padding(24)
                .background(.bgMain400, in: RoundedRectangle(cornerRadius: 32))
                .font(Font.SFPro.font(size: 17, weight: .w400))
            
            if !text.isEmpty {
                Button(
                    action: {},
                    label: {
                        Text("Dreamer.Interpret".localized)
                    }
                )
                .buttonStyle(.primary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .appBackground()
        .toolbar {
            ToolbarButton(placement: .topBarTrailing) {
                Button(
                    action: { },
                    label: { Image(systemName: "line.3.horizontal") }
                )
                .buttonStyle(.navigation)
            }
            
            ToolbarItem(placement: .principal) {
                Text("Dreamer.Title".localized)
                    .font(Font.Gambarino.font(size: 22, weight: .w400))
                    .foregroundStyle(.textMain200)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DreamerMainScreen()
    }
}
