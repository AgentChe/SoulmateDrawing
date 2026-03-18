//
//  DiscoverRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.01.2026.
//

import Alamofire

struct DiscoverRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/discover"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "anonymous_id": anonymousId
        ]
        
        params["internal_id"] = internalId
        
        return params
    }
}
