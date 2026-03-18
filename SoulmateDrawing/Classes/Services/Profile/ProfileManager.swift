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
    
    func saveAttributes(attrs: [String: Any?]) async throws {
        let request = ProfileAttributesRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            attrs: attrs
        )
        
        return try await restApiTransport.callServerApi(requestBody: request)
    }
    
    func getProfile(forceUpdate: Bool) async throws -> ProfileModel {
        if forceUpdate {
            return try await getProfile()
        } else {
            do {
                return try cachedProfile()
            } catch {
                return try await getProfile()
            }
        }
    }
}

private extension ProfileManager {
    func getProfile() async throws -> ProfileModel {
        let request = ProfileGetRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        let response: ProfileResponse = try await restApiTransport.callServerApi(requestBody: request)
        
        let model = ProfileModel(response: response)
        if let data = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(data, forKey: Constants.profileKey)
        }
        return model
    }
    
    func cachedProfile() throws -> ProfileModel {
        let data = UserDefaults.standard.data(forKey: Constants.profileKey)
        guard let data else { throw NSError(domain: "ProfileManager", code: -1) }
        return try JSONDecoder().decode(ProfileModel.self, from: data)
    }
}

private extension ProfileManager {
    enum Constants {
        static let profileKey = "profile_manager_profile_key"
    }
}

private extension ProfileModel {
    init(response: ProfileResponse) {
        self.init(
            name: response.name,
            bornDate: response.bornDate,
            city: response.bornLocation
        )
    }
}
