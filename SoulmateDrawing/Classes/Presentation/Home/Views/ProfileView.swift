//
//  ProfileView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import SwiftUI

struct MainPointsView: View {
    let mainPoints: [MainPoint]
    
    var body: some View {
        HStack(spacing: 16.scale) {
            ForEach(mainPoints, id: \.self) { model in
                HStack(spacing: 4.scale) {
                    // TODO: Поправить иконку
//                        Image(model.label.iconName)
                    Text(model.label.name)
                }
            }
        }
        .font(Font.SFPro.font(size: 17.scale, weight: .w400))
        .foregroundStyle(.textMain200)
    }
}

struct ProfileView: View {
    let name: String
    // TODO: Что-то решить с этим, возможно не нужно и с бека будет приходить
    let zodiac: Zodiac
    let mainPoints: [MainPoint]
    
    var body: some View {
        VStack(spacing: 0) {
            Image(zodiac.largeIconName)
            
            Text(name)
                .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                .foregroundStyle(.textMain200)
            
            MainPointsView(mainPoints: mainPoints)
                .padding(.top, 12.scale)
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
