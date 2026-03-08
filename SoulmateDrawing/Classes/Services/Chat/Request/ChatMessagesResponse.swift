//
//  ChatMessagesResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 25.02.2026.
//

import Foundation

struct ChatMessagesResponse: Decodable {
    let items: [MessageResponse]
    let pagingation: Pagination
}
