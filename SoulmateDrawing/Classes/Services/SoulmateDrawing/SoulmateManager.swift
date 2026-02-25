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
    
    func soulmate() async throws -> SoulmateModel {
        // TODO: Раскомментить
//        let request = SoulmateGetRequest(
//            anonymousId: sessionManager.anonymousId,
//            internalId: sessionManager.internalId
//        )
//        let response: SoulmateResponse = try await restApiTransport.callServerApi(requestBody: request)
        try await Task.sleep(for: .seconds(1))
        return SoulmateModel.mock
        //        return SoulmateModel(response: response)
    }
    
    func generateSoulmate(gender: String, ethnicity: String) async throws -> SoulmateModel {
//        let request = SoulmateGenerateRequest(
//            anonymousId: sessionManager.anonymousId,
//            internalId: sessionManager.internalId,
//            gender: gender,
//            ethnicity: ethnicity
//        )
//        
//        let response: SoulmateResponse = try await restApiTransport.callServerApi(requestBody: request)
//        
//        return SoulmateModel(response: response)
        try await Task.sleep(for: .seconds(2))
        return SoulmateModel.mock
    }
}
// Preferences
private extension SoulmateManager {
    func preferences() async throws -> SoulmatePreferencesModel {
        let request = SoulmatePreferencesRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        // TODO: - Раскомментить
//        let response: SoulmatePreferencesResponse = try await restApiTransport.callServerApi(requestBody: request)
        try await Task.sleep(for: .seconds(1))
        
        let response = SoulmatePreferencesResponse.mock
        
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
                items: exploreItems
            ),
            charts: response.charts
        )
    }
}

private extension SoulmateManager {
    enum Constants {
        static let preferencesKey = "soulmate_drawing_manager_preferences_key"
    }
}

extension SoulmateModel {
    static let mock = SoulmateModel(
        image: URL(string: "https://abrakadabra.fun/uploads/posts/2021-12/1639417366_1-abrakadabra-fun-p-krasivie-avi-zhivotnikh-1.jpg"),
        mainPoints: [
            .init(iconURL: URL(string: ""), label: .aquarius),
            .init(iconURL: URL(string: ""), label: .aries),
            .init(iconURL: URL(string: ""), label: .carpicorn),
        ],
        explore: .init(
            tip: "You may recognize this connection through a sense of emotional safety rather than instant fireworks.",
            items: [
                .init(
                    image: URL(string: "https://abrakadabra.fun/uploads/posts/2021-12/1639417325_8-abrakadabra-fun-p-krasivie-avi-zhivotnikh-8.jpg"),
                    title: "Emotional safety",
                    text: "Around him, you don’t feel the need to stay in control to feel secure. You’re naturally decisive and clear about what you want, and in many connections that turns into emotional responsibility — setting the tone, holding the balance, keeping things moving.",
                    isLocked: false,
                    unlockLabel: "Today"
                ),
                .init(
                    image: URL(string: "https://abrakadabra.fun/uploads/posts/2021-12/1639417340_13-abrakadabra-fun-p-krasivie-avi-zhivotnikh-13.jpg"),
                    title: "Being seen",
                    text: "You feel understood without needing to explain yourself.",
                    isLocked: true,
                    unlockLabel: "Unlocks in 1 day"
                ),
                .init(
                    image: URL(string: "https://abrakadabra.fun/uploads/posts/2021-12/1639417397_7-abrakadabra-fun-p-krasivie-avi-zhivotnikh-7.jpg"),
                    title: "Calm attraction",
                    text: "You feel understood without needing to explain yourself.",
                    isLocked: true,
                    unlockLabel: "Unlocks in 3 days"
                ),
                .init(
                    image: nil,
                    title: "Life flow together",
                    text: "You feel understood without needing to explain yourself.",
                    isLocked: true,
                    unlockLabel: "Unlocks in 5 days"
                ),
                .init(
                    image: nil,
                    title: "Quiet depth",
                    text: "You feel understood without needing to explain yourself.",
                    isLocked: true,
                    unlockLabel: "Unlocks in 7 days"
                )
            ]
        ),
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

    static let description = "You meet the world with softness, intuition, and emotional depth. In relationships, you crave safety, tenderness, and genuine connection. With this placement in the 7th house, partnerships become a mirror for your inner world — you attract people who awaken your protective side or who help you feel truly seen. You bond slowly but meaningfully, and once trust is built, your loyalty is unwavering. Your greatest growth comes from learning to balance your sensitivity with healthy boundaries."
}

private extension SoulmatePreferencesResponse {
    static let mock = SoulmatePreferencesResponse(
        genders: ["Male", "Female", "All"],
        ethnicities: ["European", "Latin / Hispanic", "Asian", "African"]
    )
}
