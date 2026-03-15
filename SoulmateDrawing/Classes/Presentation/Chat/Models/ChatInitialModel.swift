//
//  ChatInitialModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 14.03.2026.
//

import Foundation

enum ChatInitialModel: Identifiable, Hashable {
    case open(threadID: String)
    case start(threadID: String, insight: String, tips: [String])
    
    var id: String {
        switch self {
        case .open(let threadID):
            threadID
        case .start(let threadID, _, _):
            threadID
        }
    }
}
