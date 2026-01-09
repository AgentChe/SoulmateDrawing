//
//  ExploreType.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import Foundation

enum ExploreType: String, Hashable {
    case soulmate
    case dream
    case relationship
}

extension ExploreType {
    var text: String {
        switch self {
        case .soulmate:
            "Home.Explore.Soulmate".localized
        case .dream:
            "Home.Explore.Dream".localized
        case .relationship:
            "Home.Explore.Relationship".localized
        }
    }
    
    var imageName: String {
        rawValue
    }
}
