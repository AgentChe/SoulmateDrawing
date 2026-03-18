//
//  ChatMessageModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 01.03.2026.
//

import Foundation

struct ChatMessageModel: Hashable, Identifiable {
    let id: String
    let content: String
    let role: Role
    
    enum Role: String {
        case user
        case assistant
    }
}

extension ChatMessageModel {
    init(item: MessageResponse) {
        let role: Role = switch item.role {
        case .assistant: .assistant
        case .user: .user
        }
        
        self.init(id: item.messageID, content: item.content, role: role)
    }
}
