//
//  ProfileView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import SwiftUI
import NukeUI

struct ProfileView: View {
    let name: String
    let sign: URL?
    let mainPoints: [MainPoint]
    
    var body: some View {
        VStack(spacing: 0) {
            LazyImage(source: sign) { state in
                if let image = state.image {
                    image
                } else {
                    Color.clear
                }
            }
            .frame(width: 80.scale, height: 88.scale)
            
            Text(name)
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
            
            MainPointsView(mainPoints: mainPoints)
                .padding(.top, 12.scale)
        }
    }
}
