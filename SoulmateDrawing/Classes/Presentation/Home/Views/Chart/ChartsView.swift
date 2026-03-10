//
//  ChartsView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import SwiftUI


struct ChartsView: View {
    let charts: [Chart]
    
    var body: some View {
        VStack(spacing: 16.scale) {
            Grid(alignment: .leading, horizontalSpacing: 0) {
                ForEach(charts, id: \.self) { chart in
                    GridRow {
                        Text(chart.sign.name)
                            .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                            .frame(maxWidth: 140.scale, alignment: .leading)
                        HStack(spacing: 4) {
                            // TODO: Поправить иконку возможно
                            Image(chart.label.iconName)
                            Text(chart.label.name)
                                .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(chart.house)")
                            .font(Font.Gambarino.font(size: 22.scale, weight: .w400))
                            .gridColumnAlignment(.trailing)
                    }
                    .foregroundStyle(.textMain200)
                    if charts.last != chart {
                        Divider()
                            .gridCellUnsizedAxes(.horizontal)
                    }
                }
            }
            .padding(.bottom, 32.scale)
            
            ForEach(charts, id: \.self) { chart in
                ChartCardView(chart: chart)
            }
        }
    }
}
