//
//  AIChatHistoryResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.01.2026.
//

import Foundation

struct AIChatHistoryResponse: Decodable {
    let items: [Item]
    let pagination: Pagination
    
    struct Item: Decodable {
        let threadId: String
        let createdTimestamp: Int
        let createdAt: Date?
        let personName: String
        let petsonType: ConnectionType
        let message: Message
    }
    
    struct Message: Decodable {
        let messageId: String
        let content: String
        let role: String
        let image: URL?
        let createdAt: Date?
        let createdTimestamp: Int
    }
}
