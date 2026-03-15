//
//  SoulmateManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import Foundation

final class SoulmateManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
    
    func preferences(forceUpdate: Bool) async throws -> SoulmatePreferencesModel {
        if forceUpdate {
            return try await preferences()
        } else {
            do {
                return try cachedPreferences()
            } catch {
                return try await preferences()
            }
        }
    }
    
    func soulmate() async throws -> SoulmateModel? {
        let request = SoulmateGetRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        let response: SoulmateResponse? = try await restApiTransport.callServerApi(requestBody: request)
        return response.map { SoulmateModel(response: $0) }
    }
    
    func generateSoulmate(gender: String, ethnicity: String) async throws -> SoulmateModel {
        let request = SoulmateGenerateRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            gender: gender,
            ethnicity: ethnicity
        )
        
        let response: SoulmateResponse = try await restApiTransport.callServerApi(requestBody: request)
        
        return SoulmateModel(response: response)
    }
}
// Preferences
private extension SoulmateManager {
    func preferences() async throws -> SoulmatePreferencesModel {
        let request = SoulmatePreferencesRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        let response: SoulmatePreferencesResponse = try await restApiTransport.callServerApi(requestBody: request)
        let model = SoulmatePreferencesModel(response: response)
        
        if let data = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(data, forKey: Constants.preferencesKey)
        }
        
        return model
    }
    
    func cachedPreferences() throws -> SoulmatePreferencesModel {
        let data = UserDefaults.standard.data(forKey: Constants.preferencesKey)
        guard let data else { throw NSError(domain: "SoulmateDrawingManager", code: -1) }
        return try JSONDecoder().decode(SoulmatePreferencesModel.self, from: data)
    }
}

// Soulmate
private extension SoulmateManager {
    
}

private extension SoulmatePreferencesModel {
    init(response: SoulmatePreferencesResponse) {
        self.init(genders: response.genders, ethnicities: response.ethnicities)
    }
}

private extension SoulmateModel {
    init(response: SoulmateResponse) {
        let exploreItems: [ExploreItem] = response.explore.items
            .map {
                .init(
                    image: $0.image,
                    title: $0.title,
                    text: $0.text,
                    isLocked: $0.isLocked,
                    unlockLabel: $0.unlockLabel
                )
            }
        self.init(
            image: response.image,
            mainPoints: response.mainPoints,
            explore: .init(
                tip: response.explore.tip,
                items: exploreItems,
                charts: response.explore.charts
            )
        )
    }
}

private extension SoulmateManager {
    enum Constants {
        static let preferencesKey = "soulmate_drawing_manager_preferences_key"
    }
}
