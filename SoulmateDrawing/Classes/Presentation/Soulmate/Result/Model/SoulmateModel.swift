//
//  SoulmateModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import Foundation

struct SoulmateModel {
    let image: URL?
    let mainPoints: [MainPoint]
    let explore: Explore
    let charts: [Chart]
}

struct Explore {
    let tip: String
    let items: [ExploreItem]
}

struct ExploreItem: Hashable {
    let image: URL?
    let title: String
    let text: String
    let isLocked: Bool
    let unlockLabel: String?
}
