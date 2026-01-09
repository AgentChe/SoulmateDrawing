//
//  ProfileManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.01.2026.
//

import Foundation

final class ProfileManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
    
    func create() async throws {
        let request = ProfileCreateRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
    
    func binding() async throws {
        let request = ProfileBindingRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
    
    func saveAttributes(user: UserModel) async throws {
        let request = ProfileAttributesRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            model: user
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
}
