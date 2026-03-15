//
//  SupportManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.03.2026.
//

import Foundation

final class SupportManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
    
    func getLocations(for query: String, page: Int?) async throws -> SupportLocationResponse {
        let request = SupportLocationRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            query: query,
            page: page
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
}
