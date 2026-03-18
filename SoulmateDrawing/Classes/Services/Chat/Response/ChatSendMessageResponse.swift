//
//  ChatSendMessageResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 25.02.2026.
//

import Foundation

struct ChatSendMessageResponse: Decodable {
    let user: MessageResponse
    let assistant: MessageResponse
}
