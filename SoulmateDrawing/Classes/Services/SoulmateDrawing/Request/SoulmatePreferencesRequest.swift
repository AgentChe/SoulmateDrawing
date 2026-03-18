//
//  SoulmatePreferencesRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import Alamofire

struct SoulmatePreferencesRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/soulmate/preferences"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        let params: Parameters = [
            "anonymous_id": anonymousId,
            "internal_id": internalId
        ]
        return params
    }
}
