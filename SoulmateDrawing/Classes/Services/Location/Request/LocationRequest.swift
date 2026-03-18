//
//  LocationRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import Alamofire

struct LocationRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let query: String
    let page: Int?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/profile/create"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "anonymous_id": anonymousId,
            "query": query
        ]
        
        if let internalId {
            params["internal_id"] = internalId
        }
        
        if let page {
            params["page"] = page
        }
        
        return params
    }
}
