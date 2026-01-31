//
//  ConnectionType.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import Foundation

enum ConnectionType: String, Decodable, CaseIterable {
    case friend = "friend"
    case partner = "partner"
}

extension ConnectionType {
    var title: String {
        switch self {
        case .friend:
            "Bonds.ConnectionType.Friend".localized
        case .partner:
            "Bonds.ConnectionType.Partner".localized
        }
    }
}
