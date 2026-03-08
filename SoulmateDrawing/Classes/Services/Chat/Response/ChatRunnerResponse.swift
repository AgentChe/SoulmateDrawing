//
//  ChatRunnerResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 25.02.2026.
//

import Foundation

struct ChatRunnerResponse: Decodable {
    let runID: String
    let status: String
    let isComplete: Bool
    let content: MessageResponse?
}
