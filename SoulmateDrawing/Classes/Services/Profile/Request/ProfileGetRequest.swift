//
//  ProfileGetRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 28.01.2026.
//

import Alamofire

struct ProfileGetRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/profile/get"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId
        ]
    }
}
