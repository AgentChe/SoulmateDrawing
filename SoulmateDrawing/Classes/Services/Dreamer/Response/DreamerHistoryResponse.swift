//
//  DreamerHistoryResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.03.2026.
//

import Foundation

struct DreamerHistoryResponse: Decodable {
    let items: [Item]
    let pagination: Pagination
    
    struct Item: Decodable {
        let id: String
        let preview: String
        let date: Date
        let image: URL
    }
}
