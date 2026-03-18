//
//  ChatCreateResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 25.02.2026.
//

import Foundation

struct ChatCreateResponse: Decodable {
    let threadID: String
    let insight: String
    let tips: [String]
    
    enum CodingKeys: String, CodingKey {
        case threadID = "thread_id"
        case insight
        case tips
    }
}
