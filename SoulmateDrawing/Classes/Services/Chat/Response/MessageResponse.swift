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
    let createdDate: Date
    
    enum Role: String, Decodable {
        case assistant
        case user
    }
    
    enum CodingKeys: String, CodingKey {
        case messageID = "message_id"
        case threadID = "thread_id"
        case content
        case role
        case createdDate = "created_timestamp"
    }
}
