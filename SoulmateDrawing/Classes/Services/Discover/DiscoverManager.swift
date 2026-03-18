//
//  DiscoverManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.01.2026.
//

import Foundation

final class DiscoverManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
    
    func discover(forceUpdate: Bool) async throws -> DiscoverModel {
        if forceUpdate {
            return try await discover()
        } else {
            do {
                return try cachedDiscover()
            } catch {
                return try await discover()
            }
        }
    }
    
    private func discover() async throws -> DiscoverModel {
        let request = DiscoverRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        let response: DiscoverModel = try await restApiTransport.callServerApi(requestBody: request)
        
        if let data = try? JSONEncoder().encode(response) {
            UserDefaults.standard.set(data, forKey: Constants.discoverKey)
        }
        
        return response
    }
    
    private func cachedDiscover() throws -> DiscoverModel {
        let data = UserDefaults.standard.data(forKey: Constants.discoverKey)
        guard let data else { throw NSError(domain: "DiscoverManager", code: -1) }
        return try JSONDecoder().decode(DiscoverModel.self, from: data)
    }
}

private extension DiscoverManager {
    enum Constants {
        static let discoverKey = "discover_manager_discover_key"
    }
}
