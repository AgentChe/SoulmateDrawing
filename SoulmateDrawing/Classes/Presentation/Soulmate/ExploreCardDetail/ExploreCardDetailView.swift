//
//  ExploreCardDetailView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import SwiftUI
import NukeUI

struct ExploreCardDetailView: View {
    let item: ExploreItem
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 24.scale) {
                Text(item.title)
                    .font(Font.Gambarino.font(size: 32.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
                    .padding(.top, 174.scale)
                
                Text(item.text)
                    .font(Font.SFPro.font(size: 17.scale, weight: .w400))
                    .foregroundStyle(.textMain200)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 24.scale)
            .frame(maxWidth: .infinity)
        }
        .background(alignment: .top) {
            LazyImage(source: item.image) { state in
                if let image = state.image {
                    image
                        .aspectRatio(1.09, contentMode: .fit)
                        .overlay(alignment: .top) {
                            let color = Color(red: 1, green: 240/255, blue: 223/255)
                            LinearGradient(
                                stops: [
                                    .init(color: color.opacity(0), location: 0.62),
                                    .init(color: color, location: 0.84)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                }
            }
            .ignoresSafeArea()
        }
        .background(.bgMain100)
        .customBackButton()
    }
}

#Preview {
    NavigationStack {
        ExploreCardDetailView(item: .init(
            image: URL(string: "https://abrakadabra.fun/uploads/posts/2021-12/1639417325_8-abrakadabra-fun-p-krasivie-avi-zhivotnikh-8.jpg"),
            title: "Emotional safety",
            text: "Around him, you don’t feel the need to stay in control to feel secure. You’re naturally decisive and clear about what you want, and in many connections that turns into emotional responsibility — setting the tone, holding the balance, keeping things moving.",
            isLocked: false,
            unlockLabel: "Today"
        ))
    }
}
