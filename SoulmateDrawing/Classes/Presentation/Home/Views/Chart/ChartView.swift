//
//  ChartView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import SwiftUI

struct ChartView: View {
    let chart: Chart
    
    var body: some View {
        HStack {
            Text(chart.sign.name)
                .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                .gridColumnAlignment(.leading)
            
            HStack(spacing: 4.scale) {
                // TODO: Поправить иконку возможно
                Image(chart.label.iconName)
                Text(chart.label.name)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
            }
            .frame(maxWidth: .infinity)
            
            Text("\(chart.house)")
                .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                .gridColumnAlignment(.trailing)
        }
        .foregroundStyle(.textMain200)
    }
}
