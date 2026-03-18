//
//  ChartsView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import SwiftUI
import NukeUI

struct ChartsView: View {
    let charts: [Chart]
    
    var body: some View {
        VStack(spacing: 16.scale) {
            Grid(alignment: .leading, horizontalSpacing: 0) {
                ForEach(charts, id: \.self) { chart in
                    GridRow {
                        Text(chart.sign)
                            .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                            .frame(maxWidth: 140.scale, alignment: .leading)
                        HStack(spacing: 4) {
                            
                            LazyImage(source: chart.icon) { state in
                                if let image = state.image {
                                    image
                                } else {
                                    Color.clear
                                }
                            }
                            .frame(width: 24, height: 24)

                            Text(chart.label)
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
