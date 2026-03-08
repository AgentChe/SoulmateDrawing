//
//  ChatSendMessageResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 25.02.2026.
//

import Foundation

struct ChatSendMessageResponse: Decodable {
    let runner: Runner
    let user: MessageResponse
}

extension ChatSendMessageResponse {
    struct Runner: Decodable {
        let runID: String
        let status: String
        let isComplete: Bool
    }
}
