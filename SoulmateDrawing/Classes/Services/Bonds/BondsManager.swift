//
//  BondsManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import Foundation

final class BondsManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
    
    func createPerson(_ person: NewPersonModel) async throws -> PersonResponse {
        let request = BondsCreatePersonRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            model: person
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
    
    func personList(page: Int?) async throws -> ProfileListResponse {
        let request = BondsPersonListRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            page: page
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
}

private extension BondsManager {
    enum Constants {
        static let personListKey = "bonds_manager_person_list_key"
    }
}
