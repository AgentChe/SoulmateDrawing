//
//  ChatHistoryResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.01.2026.
//

import Foundation

struct ChatHistoryResponse: Decodable {
    let items: [Item]
    let pagination: Pagination
    
    struct Item: Decodable {
        let threadId: String
        let createdDate: Date
        let personName: String
        let petsonType: ConnectionType
        let message: Message
        
        enum CodingKeys: String, CodingKey {
            case threadId = "thread_id"
            case createdDate = "created_timestamp"
            case personName = "person_name"
            case petsonType = "person_type"
            case message
        }
    }
    
    struct Message: Decodable {
        let messageId: String
        let content: String
        let role: String
        let createdDate: Date
        
        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
            case content
            case role
            case createdDate = "created_timestamp"
        }
    }
}
