//
//  ProfileResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 28.01.2026.
//

import Foundation

struct ProfileResponse {
    let name: String
    let bornDate: Date?
    let bornLocation: String
}

extension ProfileResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case bornDate = "birth_datetime"
        case bornLocation = "birth_location"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.bornDate = try container.decodeIfPresent(Date.self, forKey: .bornDate)
        self.bornLocation = try container.decode(String.self, forKey: .bornLocation)
    }
}
