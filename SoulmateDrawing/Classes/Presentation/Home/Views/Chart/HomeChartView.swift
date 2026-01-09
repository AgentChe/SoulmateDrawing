//
//  HomeChartView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import SwiftUI


struct HomeChartView: View {
    let charts: [Chart]
    
    var body: some View {
        LazyVStack(spacing: 16) {
            Grid(alignment: .leading, horizontalSpacing: 0) {
                ForEach(charts, id: \.self) { chart in
                    GridRow {
                        Text(chart.sign.name)
                            .font(Font.SFPro.font(size: 17, weight: .w400))
                            .frame(maxWidth: 140, alignment: .leading)
                        HStack(spacing: 4) {
                            // TODO: Поправить иконку возможно
                            Image(chart.label.iconName)
                            Text(chart.label.name)
                                .font(Font.SFPro.font(size: 17, weight: .w400))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(chart.house)")
                            .font(Font.Gambarino.font(size: 22, weight: .w400))
                            .gridColumnAlignment(.trailing)
                    }
                    .foregroundStyle(.textMain200)
                    if charts.last != chart {
                        Divider()
                            .gridCellUnsizedAxes(.horizontal)
                    }
                }
            }
            .padding(.bottom, 32)
            
            ForEach(charts, id: \.self) { chart in
                ChartCardView(chart: chart)
            }
        }
    }
}
