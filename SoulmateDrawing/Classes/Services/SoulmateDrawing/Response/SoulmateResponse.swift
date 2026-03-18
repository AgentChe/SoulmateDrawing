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
    
    enum CodingKeys: String, CodingKey {
        case image
        case mainPoints = "main_points"
        case explore
    }
}

struct SoulmateExploreResponse: Decodable {
    let tip: String
    let items: [Item]
    let charts: [Chart]
    
    struct Item: Decodable {
        let image: URL?
        let title: String
        let text: String
        let isLocked: Bool
        let unlockLabel: String?
        
        enum CodingKeys: String, CodingKey {
            case image
            case title
            case text
            case isLocked = "is_locked"
            case unlockLabel = "unlock_label"
        }
    }
}
