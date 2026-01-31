//
//  AIChatCreateThreadRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.01.2026.
//

import Alamofire

struct AIChatCreateThreadRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let personId: String
    let connectionType: ConnectionType
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/ai/chat/create"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "anonymous_id": anonymousId
        ]
        
        params["internal_id"] = internalId
        params["person_id"] = personId
        params["person_type"] = connectionType.rawValue
        
        return params
    }
}
