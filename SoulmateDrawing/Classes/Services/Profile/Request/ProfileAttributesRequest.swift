//
//  ProfileAttributesRequest.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import Alamofire

struct ProfileAttributesRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let model: ProfileModel
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1//profile/attributes"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var attrs: [String: Any] = [
            "name": model.name,
            "birth_location": model.city
        ]
        
        attrs["birth_datetime"] = model.bornDate?.timeIntervalSince1970
        
        var params: Parameters = [
            "anonymous_id": anonymousId,
            "attrs": attrs
        ]
        
        if let internalId {
            params["internal_id"] = internalId
        }
        
        return params
    }
}
