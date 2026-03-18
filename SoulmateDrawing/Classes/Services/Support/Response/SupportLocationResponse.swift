//
//  SupportLocationResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.03.2026.
//

import Foundation

struct SupportLocationResponse: Decodable {
    let items: [Item]
    let pagination: Pagination
}

extension SupportLocationResponse {
    struct Item: Decodable {
        let id: String
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case name = "Name"
        }
    }
}
