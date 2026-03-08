//
//  ChatHistoryRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.01.2026.
//

import Alamofire

struct ChatHistoryRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let page: Int?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/ai/chat/history"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "anonymous_id": anonymousId
        ]
        
        params["internal_id"] = internalId
        params["page"] = page
        
        return params
    }
}
