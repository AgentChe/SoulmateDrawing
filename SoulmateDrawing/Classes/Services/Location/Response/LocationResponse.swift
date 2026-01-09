//
//  LocationResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import Foundation

struct LocationResponse: Codable {
    let items: [Location]
    let pagination: [Pagination]
    
    struct Location: Codable {
        let id: UUID
        let name: String
    }
    
    struct Pagination: Codable {
        let total: Int
        let current: Int
        let next: Int
    }
}
