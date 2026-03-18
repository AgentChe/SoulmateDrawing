//
//  SoulmateSegmentItem.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 14.03.2026.
//

import Foundation

enum SoulmateSegmentItem: Hashable, CaseIterable {
    case explore
    case chart
    
    var name: String {
        switch self {
        case .explore:
            "Soulmate.Segment.Explore".localized
        case .chart:
            "Soulmate.Segment.Chart".localized
        }
    }
}
