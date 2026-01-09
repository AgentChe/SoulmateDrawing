//
//  HomeSegmentItem.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 20.12.2025.
//

import Foundation

enum HomeSegmentItem: CaseIterable, Hashable {
    case explore
    case chart
    
    var name: String {
        switch self {
        case .explore:
            "Home.Segment.Explore".localized
        case .chart:
            "Home.Segment.Chart".localized
        }
    }
}
