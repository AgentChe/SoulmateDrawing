//
//  ChatDeleteRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 25.02.2026.
//

import Alamofire

struct ChatDeleteRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let threadID: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/ai/chat/delete"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        let params: Parameters = [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "thread_id": threadID,
        ]
        return params
    }
}
