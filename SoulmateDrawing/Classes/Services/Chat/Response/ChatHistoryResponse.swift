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
        let createdTimestamp: Int
        let createdAt: Date
        let personName: String
        let petsonType: ConnectionType
        let message: Message
    }
    
    struct Message: Decodable {
        let messageId: String
        let content: String
        let role: String
        let image: URL?
        let createdAt: Date
        let createdTimestamp: Int
    }
}

extension ChatHistoryResponse {
    static let mock = ChatHistoryResponse(
        items: [
            .init(
                threadId: UUID().uuidString,
                createdTimestamp: Int(Date().timeIntervalSince1970),
                createdAt: .init(),
                personName: "Margo",
                petsonType: .friend,
                message: .init(
                    messageId: UUID().uuidString,
                    content: "What makes my friendship with Margo special?",
                    role: "user",
                    image: nil,
                    createdAt: .init(),
                    createdTimestamp: Int(Date().timeIntervalSince1970)
                )
            ),
            .init(
                threadId: UUID().uuidString,
                createdTimestamp: Int(Date().timeIntervalSince1970),
                createdAt: .init(),
                personName: "Madison",
                petsonType: .partner,
                message: .init(
                    messageId: UUID().uuidString,
                    content: "Why do we sometimes misunderstand each other, and how can we communicate better",
                    role: "user",
                    image: nil,
                    createdAt: .init(),
                    createdTimestamp: Int(Date().timeIntervalSince1970)
                )
            ),
            .init(
                threadId: UUID().uuidString,
                createdTimestamp: Int(Date().timeIntervalSince1970),
                createdAt: .init(),
                personName: "Liam",
                petsonType: .friend,
                message: .init(
                    messageId: UUID().uuidString,
                    content: "What creates the strongest emotional connection between us",
                    role: "user",
                    image: nil,
                    createdAt: .init(),
                    createdTimestamp: Int(Date().timeIntervalSince1970)
                )
            ),
            .init(
                threadId: UUID().uuidString,
                createdTimestamp: Int(Date().timeIntervalSince1970),
                createdAt: .init(),
                personName: "Liam",
                petsonType: .partner,
                message: .init(
                    messageId: UUID().uuidString,
                    content: "What makes my friendship with Ivan special?",
                    role: "user",
                    image: nil,
                    createdAt: .init(),
                    createdTimestamp: Int(Date().timeIntervalSince1970)
                )
            )
        ],
        pagination: .init(total: 4, current: 1, next: 1)
    )
}
