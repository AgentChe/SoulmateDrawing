//
//  SoulmateGenerateRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import Alamofire

struct SoulmateGenerateRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let gender: String
    let ethnicity: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/soulmate/generate"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        let params: Parameters = [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "gender": gender,
            "ethnicity": ethnicity
        ]
        
        return params
    }
}
