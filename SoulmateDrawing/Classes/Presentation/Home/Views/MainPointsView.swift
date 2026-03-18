//
//  MainPointsView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import SwiftUI
import NukeUI

struct MainPointsView: View {
    let mainPoints: [MainPoint]
    
    var body: some View {
        HStack(spacing: 16.scale) {
            ForEach(mainPoints, id: \.self) { model in
                HStack(spacing: 4.scale) {
                    LazyImage(source: model.iconURL) { state in
                        if let image = state.image {
                            image
                        } else {
                            Color.clear
                        }
                    }
                    .frame(width: 20, height: 20)
                    
                    Text(model.label)
                }
            }
        }
        .font(Font.SFPro.font(size: 17.scale, weight: .w400))
        .foregroundStyle(.textMain200)
    }
}
