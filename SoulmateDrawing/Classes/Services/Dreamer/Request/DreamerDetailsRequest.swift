//
//  DreamerDetailsRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.03.2026.
//

import Alamofire

struct DreamerDetailsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let dreamID: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/dreamer/reveal"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "dream_id": dreamID
        ]
    }
}
