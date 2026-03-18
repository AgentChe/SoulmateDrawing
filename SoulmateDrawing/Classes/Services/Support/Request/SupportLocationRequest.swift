//
//  SupportLocationRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.03.2026.
//

import Alamofire

struct SupportLocationRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let query: String
    let page: Int?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/locations"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "query": query,
            "page": page
        ]
    }
}
