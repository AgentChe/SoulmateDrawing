//
//  AIChatCreateThreadResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.01.2026.
//

import Foundation

struct AIChatCreateThreadResponse: Decodable {
    let threadId: String
    let insight: String
    let tips: [String]
}
