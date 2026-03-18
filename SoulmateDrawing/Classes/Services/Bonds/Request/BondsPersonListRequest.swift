//
//  BondsPersonListRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import Alamofire

struct BondsPersonListRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let page: Int?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/persons/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        let params: Parameters = [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "page": page
        ]
        
        return params
    }
}
