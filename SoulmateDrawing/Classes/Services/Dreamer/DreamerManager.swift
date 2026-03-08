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
        
        try await Task.sleep(for: .seconds(1))
        // TODO: Расскоментировать
//        return try await restApiTransport.callServerApi(requestBody: request)
        return .mock
    }
    
    func dreamHistory(page: Int?) async throws -> DreamerHistoryResponse {
        let request = DreamerHistoryRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        try await Task.sleep(for: .seconds(1))
        // TODO: Расскоментировать
//        return try await restApiTransport.callServerApi(requestBody: request)
        return .mock
    }
    
    func dreamDetails(dreamID: String) async throws -> DreamerRevealResponse {
        let request = DreamerDetailsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            dreamID: dreamID
        )
        try await Task.sleep(for: .seconds(1))
        // TODO: Расскоментировать
//        return try await restApiTransport.callServerApi(requestBody: request)
        return .mock
    }
}

private extension DreamerRevealResponse {
    static let mock = DreamerRevealResponse(
        image: URL(string: "https://abrakadabra.fun/uploads/posts/2021-12/1639417325_8-abrakadabra-fun-p-krasivie-avi-zhivotnikh-8.jpg")!,
        text: "The corridor that becomes brighter can symbolize moving toward clarity, truth, or resolution. The sense of your body dissolving without fear often reflects a desire to let go of something heavy—identity, pressure, expectations, or an emotional burden. The calm, receiving light suggests acceptance: a part of you may be ready for a transition, ending, or transformation in waking life. In many symbolic frameworks, “death” in dreams isn’t literal. It usually reflects the closure of one phase and the emergence of another—an ego shift, a new self-concept, or the release of something that no longer fits you. Overall, the dream feels less like an ending and more like your psyche rehearsing a peaceful change."
    )
}

private extension DreamerHistoryResponse {
    static let mock = DreamerHistoryResponse(
        items: [
            .init(
                id: "1",
                preview: "The corridor that becomes brighter can ",
                date: Int(Date().timeIntervalSince1970),
                image: URL(string: "https://abrakadabra.fun/uploads/posts/2021-12/1639417325_8-abrakadabra-fun-p-krasivie-avi-zhivotnikh-8.jpg")!
            ),
            .init(
                id: "2",
                preview: "The corridor that becomes brighter can ",
                date: Int(Date().timeIntervalSince1970),
                image: URL(string: "https://abrakadabra.fun/uploads/posts/2021-12/1639417340_13-abrakadabra-fun-p-krasivie-avi-zhivotnikh-13.jpg")!
            ),
            .init(
                id: "3",
                preview: "The corridor that becomes brighter can ",
                date: Int(Date().timeIntervalSince1970),
                image: URL(string: "https://abrakadabra.fun/uploads/posts/2021-12/1639417397_7-abrakadabra-fun-p-krasivie-avi-zhivotnikh-7.jpg")!
            )
        ],
        pagination: .init(total: 1, current: 1, next: 1)
    )
}
