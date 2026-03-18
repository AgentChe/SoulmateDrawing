//
//  ChatCreateRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 25.02.2026.
//

import Alamofire

struct ChatCreateRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let personID: String
    let personType: ConnectionType
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/ai/chat/create"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        let params: Parameters = [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "person_id": personID,
            "person_type": personType.rawValue
        ]
        return params
    }
}
