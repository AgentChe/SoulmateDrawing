//
//  LocationManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import Foundation

final class LocationManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
    
    func location(for query: String, page: Int?) async throws -> [LocationResponse] {
        let request = LocationRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            query: query,
            page: page
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
}
