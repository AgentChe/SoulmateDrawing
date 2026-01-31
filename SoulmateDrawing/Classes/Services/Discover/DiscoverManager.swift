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
        // TODO: Раскомментить
//        let response = try await restApiTransport.callServerApi(requestBody: request)
        
        try await Task.sleep(for: .seconds(1.5))
        let response = DiscoverModel(
            mainPoints: [
                .init(iconURL: URL(string: ""), label: .aquarius),
                .init(iconURL: URL(string: ""), label: .aries),
                .init(iconURL: URL(string: ""), label: .carpicorn),
            ],
            charts: [
                .init(sign: .aquarius, label: .jupiter, icon: URL(string: ""), house: 7, description: description),
                .init(sign: .aries, label: .mars, icon: URL(string: ""), house: 8, description: description),
                .init(sign: .cancer, label: .rising, icon: URL(string: ""), house: 6, description: description),
                .init(sign: .carpicorn, label: .moon, icon: URL(string: ""), house: 9, description: description),
                .init(sign: .gemini, label: .pluto, icon: URL(string: ""), house: 5, description: description),
                .init(sign: .leo, label: .mercury, icon: URL(string: ""), house: 3, description: description),
                .init(sign: .libra, label: .neptune, icon: URL(string: ""), house: 8, description: description),
                .init(sign: .pisces, label: .saturn, icon: URL(string: ""), house: 7, description: description),
                .init(sign: .sagittarius, label: .venus, icon: URL(string: ""), house: 7, description: description),
                .init(sign: .taurus, label: .sun, icon: URL(string: ""), house: 7, description: description),
                .init(sign: .virgo, label: .venus, icon: URL(string: ""), house: 7, description: description)
            ]
        )
        
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
    
    private let description = "You meet the world with softness, intuition, and emotional depth. In relationships, you crave safety, tenderness, and genuine connection. With this placement in the 7th house, partnerships become a mirror for your inner world — you attract people who awaken your protective side or who help you feel truly seen. You bond slowly but meaningfully, and once trust is built, your loyalty is unwavering. Your greatest growth comes from learning to balance your sensitivity with healthy boundaries."
}

private extension DiscoverManager {
    enum Constants {
        static let discoverKey = "discover_manager_discover_key"
    }
}
