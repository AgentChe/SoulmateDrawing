//
//  BondsCreatePersonRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import Alamofire

struct BondsCreatePersonRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let model: NewPersonModel
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/persons/create"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "anonymous_id": anonymousId,
            "name": model.name,
            "birth_datetime": model.bornDate.timeIntervalSince1970,
            "birth_location": model.city,
            "gender": model.gender.rawValue
        ]
        
        if let internalId {
            params["internal_id"] = internalId
        }
        
        return params
    }
}
