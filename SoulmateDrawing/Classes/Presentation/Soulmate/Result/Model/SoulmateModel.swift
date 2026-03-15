//
//  SoulmateModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import Foundation

struct SoulmateModel: Hashable {
    let image: URL?
    let mainPoints: [MainPoint]
    let explore: Explore
}

struct Explore: Hashable {
    let tip: String
    let items: [ExploreItem]
    let charts: [Chart]
}

struct ExploreItem: Hashable {
    let image: URL?
    let title: String
    let text: String
    let isLocked: Bool
    let unlockLabel: String?
}
