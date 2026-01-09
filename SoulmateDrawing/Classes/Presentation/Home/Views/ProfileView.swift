//
//  ProfileView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import SwiftUI

struct ProfileView: View {
    let name: String
    let zodiac: Zodiac
    let mainPoints: [MainPoint]
    
    var body: some View {
        VStack(spacing: 0) {
            Image(zodiac.largeIconName)
            
            Text(name)
                .font(Font.Gambarino.font(size: 32, weight: .w400))
                .foregroundStyle(.textMain200)
            
            HStack(spacing: 16) {
                ForEach(mainPoints, id: \.self) { model in
                    HStack(spacing: 4) {
                        // TODO: Поправить иконку
//                        Image(model.label.iconName)
                        Text(model.label.name)
                    }
                }
            }
            .font(Font.SFPro.font(size: 17, weight: .w400))
            .foregroundStyle(.textMain200)
            .padding(.top, 12)
        }
    }
}

#Preview {
    ProfileView(
        name: "Megan",
        zodiac: .aries,
        mainPoints: [
            .init(iconURL: URL(string: ""), label: .aquarius),
            .init(iconURL: URL(string: ""), label: .carpicorn),
            .init(iconURL: URL(string: ""), label: .libra),
        ]
    )
}
