//
//  Toggle+Styles.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 07.01.2026.
//

import SwiftUI

extension ToggleStyle where Self == PaygateSwitchStyle {
    static var paygate: Self { .init() }
}

struct PaygateSwitchStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        let fillColor = configuration.isOn
            ? Color.main200
            : Color.main300
        
        HStack {
            configuration.label
                .foregroundStyle(.mono100)
            Spacer()
            RoundedRectangle(cornerRadius: 30)
                .fill(fillColor)
                .overlay {
                    Circle()
                        .fill(.white)
                        .padding(2)
                        .offset(x: configuration.isOn ? 10 : -10)
                }
                .frame(width: 51, height: 31)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}
