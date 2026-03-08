//
//  ChatRunnerRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 25.02.2026.
//

import Alamofire

struct ChatRunnerRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let threadID: String
    let runID: String
    
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/ai/chat/runner"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        let params: Parameters = [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "thread_id": threadID,
            "run_id": runID
        ]
        return params
    }
}
