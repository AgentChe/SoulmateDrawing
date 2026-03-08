//
//  MessageResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 01.03.2026.
//

import Foundation

struct MessageResponse: Decodable {
    let messageID: String
    let threadID: String
    let content: String
    let role: Role
    let createdAt: Date
    let createdTimestamp: Int
    
    enum Role: String, Decodable {
        case assistant
        case user
    }
}
