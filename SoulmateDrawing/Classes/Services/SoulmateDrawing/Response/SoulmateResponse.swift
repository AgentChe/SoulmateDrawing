//
//  SoulmateResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import Foundation

struct SoulmateResponse: Decodable {
    let image: URL?
    let mainPoints: [MainPoint]
    let explore: SoulmateExploreResponse
    let charts: [Chart]
}

struct SoulmateExploreResponse: Decodable {
    let tip: String
    let items: [Item]
    
    struct Item: Decodable {
        let image: URL?
        let title: String
        let text: String
        let isLocked: Bool
        let unlockLabel: String?
    }
}
