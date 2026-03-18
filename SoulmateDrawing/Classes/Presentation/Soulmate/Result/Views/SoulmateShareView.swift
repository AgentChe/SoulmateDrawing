//
//  SoulmateShareView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import SwiftUI

struct SoulmateShareView: View {
    let content: SoulmateSnapshotContent
    
    var body: some View {
        VStack(spacing: 24.scale) {
            Text("Soulmate Drawing")
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
            
            RoundedRectangle(cornerRadius: 32.scale)
                .fill(Color(red: 1, green: 251/255, blue: 435/255))
                .aspectRatio(0.98, contentMode: .fit)
                .overlay {
                    if let image = content.image {
                        image
                            .resizable()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 32.scale))
            
            MainPointsSnapshotView(mainPoints: content.points)
        }
        .padding(24)
        .appBackground()
        .frame(width: 402)
        .clipShape(RoundedRectangle(cornerRadius: 32.scale))
    }
}

struct MainPointsSnapshotView: View {
    let mainPoints: [SoulmateSnapshotContent.Point]
    
    var body: some View {
        HStack(spacing: 16.scale) {
            ForEach(mainPoints, id: \.self) { model in
                HStack(spacing: 4.scale) {
                    Group {
                        if let image = model.image {
                            image
                                .resizable()
                                .renderingMode(.template)
                        } else {
                            Color.clear
                        }
                    }
                    .frame(width: 20, height: 20)
                    
                    Text(model.label)
                }
            }
        }
        .font(Font.SFPro.font(size: 16.scale, weight: .w400))
        .foregroundStyle(Color(red: 68/255, green: 68/255, blue: 68/255))
    }
}
