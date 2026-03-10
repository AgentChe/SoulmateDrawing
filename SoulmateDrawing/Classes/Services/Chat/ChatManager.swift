//
//  ChatManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.01.2026.
//

import Foundation

final class ChatManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
    
    func getHistory(page: Int?) async throws -> ChatHistoryResponse {
        let request = ChatHistoryRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            page: page
        )
        // TODO: Раскомментить
//        return try await restApiTransport.callServerApi(requestBody: request)
        try await Task.sleep(for: .seconds(1))
        return ChatHistoryResponse.mock
    }
    
    func createThread(for personId: String, use connectionType: ConnectionType) async throws -> ChatCreateResponse {
        let request = ChatCreateRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            personID: personId,
            personType: connectionType
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
    
    func getMessages(for threadID: String, page: Int?) async throws -> ChatMessagesResponse {
        let request = ChatMessagesRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            threadID: threadID,
            page: page
        )
        try await Task.sleep(for: .seconds(0))
        // TODO: Раскомментить
//        return try await restApiTransport.callServerApi(requestBody: request)
        return getChatMessagesResponse(currentPage: page)
    }
    
    func sendMessage(message: String, threadID: String) async throws -> ChatSendMessageResponse {
        let request = ChatSendMessageRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            threadID: threadID,
            message: message
        )
        // TODO: Раскомментить
//        return try await restApiTransport.callMultipartServerApi(requestBody: request)
        try await Task.sleep(for: .seconds(1))
        return ChatSendMessageResponse(
            runner: .init(
                runID: UUID().uuidString,
                status: "queued",
                isComplete: false
            ),
            user: .init(
                messageID: UUID().uuidString,
                threadID: threadID,
                content: message,
                role: .user,
                createdAt: .init(),
                createdTimestamp: .init()
            )
        )
    }
    
    func checkRunner(runID: String, for threadID: String) async throws -> ChatRunnerResponse {
        let request = ChatRunnerRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            threadID: threadID,
            runID: runID
        )
        // TODO: Раскомментить
//        return try await restApiTransport.callServerApi(requestBody: request)
        let random = [0, 1, 10, 13, 20, 50].randomElement() ?? 0
        try await Task.sleep(for: .seconds(0.5))
        if random == 50 {
            return ChatRunnerResponse(
                runID: runID,
                status: "completed",
                isComplete: true,
                content: .init(
                    messageID: UUID().uuidString,
                    threadID: threadID,
                    content: "Ответ от ИИ",
                    role: .assistant,
                    createdAt: .init(),
                    createdTimestamp: .init()
                )
            )
        } else {
            return ChatRunnerResponse(
                runID: runID,
                status: "queued",
                isComplete: false,
                content: nil
            )
        }
    }
    
    func chatDelete(threadID: String) async throws {
        let request = ChatDeleteRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            threadID: threadID
        )
        
        try await restApiTransport.callServerApi(requestBody: request)
    }
    
    private func getChatMessagesResponse(currentPage: Int?) -> ChatMessagesResponse {
        let currentPage = currentPage ?? 1
        return ChatMessagesResponse(
            items: [
                .init(
                    messageID: UUID().uuidString,
                    threadID: "1234567890",
                    content: "What’s unsaid between me and Margo?",
                    role: .user,
                    createdAt: .init(),
                    createdTimestamp: 1
                ),
                .init(
                    messageID: UUID().uuidString,
                    threadID: "1234567890",
                    content: "You and Margo share an easy sense of trust and emotional safety. But some of the most interesting dynamics in your friendship show up in how you handle change and stress.",
                    role: .assistant,
                    createdAt: .init(),
                    createdTimestamp: 1
                ),
                .init(
                    messageID: UUID().uuidString,
                    threadID: "1234567890",
                    content: "Why do some moments feel intense?",
                    role: .user,
                    createdAt: .init(),
                    createdTimestamp: .init()
                ),
                .init(
                    messageID: UUID().uuidString,
                    threadID: "1234567890",
                    content: "You both have strong personalities that can clash at times, but Margo tends to take things more personally because she's wired to feel deeply and can be sensitive to criticism or perceived slights. Your natural independence might trigger her fears of being dismissed, while her serious approach could sometimes feel controlling to you. That said, you also have moments where you react strongly when you feel she's questioning your choices or trying to impose structure on your free-spirited nature. The beauty is that you both actually help balance each other out - she grounds you while you help her lighten up.",
                    role: .assistant,
                    createdAt: .init(),
                    createdTimestamp: 1
                ),
                .init(
                    messageID: UUID().uuidString,
                    threadID: "1234567890",
                    content: "What makes my friendship with Margo special?",
                    role: .user,
                    createdAt: .init(),
                    createdTimestamp: .init()
                )
            ],
            pagingation: .init(total: 10, current: currentPage, next: min(currentPage + 1, 10))
        )
    }
}
