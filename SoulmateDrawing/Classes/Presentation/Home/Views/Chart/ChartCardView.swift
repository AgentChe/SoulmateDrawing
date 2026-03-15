//
//  ChartCardView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import SwiftUI

struct ChartCardView: View {
    let chart: Chart
    
    var body: some View {
        Button(action: {}) {
            VStack(alignment: .leading, spacing: 12.scale) {
                Text(chart.formattedTitle)
                    .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                
                Text(chart.description)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
            }
            .foregroundStyle(.textMain200)
            .padding(24.scale)
            .background(.bgMain200, in: RoundedRectangle(cornerRadius: 32.scale))
            .shadow(color: Color.black.opacity(0.1), radius: 53, y: 21)
            .shadow(color: Color.white.opacity(0.04), radius: 42, y: 10)
            .shadow(color: Color.white.opacity(0.16), radius: 0, y: 1.34)
            
        }
        .buttonStyle(.card)
    }
}

extension ButtonStyle where Self == CardButtonStyle {
    static var card: Self { .init() }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.75 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

private extension Chart {
    var formattedTitle: String {
        "\(sign) \(label) · \("House".localized) \(house)"
    }
}
