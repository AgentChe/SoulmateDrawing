//
//  AIChatManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.01.2026.
//

import Foundation

final class AIChatManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
    
    func getHistory(page: Int?) async throws -> AIChatHistoryResponse {
        let request = AIChatHistoryRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            page: page
        )
        // TODO: Раскомментить
//        return try await restApiTransport.callServerApi(requestBody: request)
        try await Task.sleep(for: .seconds(1))
        return AIChatHistoryResponse(
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
    
    func createThread(for personId: String, use connectionType: ConnectionType) async throws -> AIChatCreateThreadResponse {
        let request = AIChatCreateThreadRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            personId: personId,
            connectionType: connectionType
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
}
