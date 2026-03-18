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
        
        return try await restApiTransport.callServerApi(requestBody: request)
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
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
    
    func sendMessage(message: String, threadID: String) async throws -> ChatSendMessageResponse {
        let request = ChatSendMessageRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            threadID: threadID,
            message: message
        )
        
        return try await restApiTransport.callMultipartServerApi(requestBody: request)
    }
    
    func chatDelete(threadID: String) async throws {
        let request = ChatDeleteRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            threadID: threadID
        )
        
        try await restApiTransport.callServerApi(requestBody: request)
    }
}
