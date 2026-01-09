//
//  HomeViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.01.2026.
//

import Foundation

@Observable
final class HomeViewModel {
    private(set) var mainPoints: [MainPoint] = []
    private(set) var charts: [Chart] = []
    
    func load() async {
        try? await Task.sleep(for: .seconds(0))
        let discovery = DiscoverModel(
            mainPoints: [
                .init(iconURL: URL(string: ""), label: .aquarius),
                .init(iconURL: URL(string: ""), label: .aries),
                .init(iconURL: URL(string: ""), label: .carpicorn),
            ],
            charts: [
                .init(sign: .aquarius, label: .jupiter, icon: URL(string: ""), house: 7, description: description),
                .init(sign: .aries, label: .mars, icon: URL(string: ""), house: 8, description: description),
                .init(sign: .cancer, label: .rising, icon: URL(string: ""), house: 6, description: description),
                .init(sign: .carpicorn, label: .moon, icon: URL(string: ""), house: 9, description: description),
                .init(sign: .gemini, label: .pluto, icon: URL(string: ""), house: 5, description: description),
                .init(sign: .leo, label: .mercury, icon: URL(string: ""), house: 3, description: description),
                .init(sign: .libra, label: .neptune, icon: URL(string: ""), house: 8, description: description),
                .init(sign: .pisces, label: .saturn, icon: URL(string: ""), house: 7, description: description),
                .init(sign: .sagittarius, label: .venus, icon: URL(string: ""), house: 7, description: description),
                .init(sign: .taurus, label: .sun, icon: URL(string: ""), house: 7, description: description),
                .init(sign: .virgo, label: .venus, icon: URL(string: ""), house: 7, description: description)
            ]
        )
        
        await MainActor.run {
            mainPoints = discovery.mainPoints
            charts = discovery.charts
        }
    }
    
    private let description = "You meet the world with softness, intuition, and emotional depth. In relationships, you crave safety, tenderness, and genuine connection. With this placement in the 7th house, partnerships become a mirror for your inner world — you attract people who awaken your protective side or who help you feel truly seen. You bond slowly but meaningfully, and once trust is built, your loyalty is unwavering. Your greatest growth comes from learning to balance your sensitivity with healthy boundaries."
}
