//
//  DreamerManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.03.2026.
//

import Foundation

final class DreamerManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
    
    func interpretation(dream: String) async throws -> DreamerRevealResponse {
        let request = DreamerRevealRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            dreamText: dream
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
    
    func dreamHistory(page: Int?) async throws -> DreamerHistoryResponse {
        let request = DreamerHistoryRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
    
    func dreamDetails(dreamID: String) async throws -> DreamerRevealResponse {
        let request = DreamerDetailsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            dreamID: dreamID
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
}
