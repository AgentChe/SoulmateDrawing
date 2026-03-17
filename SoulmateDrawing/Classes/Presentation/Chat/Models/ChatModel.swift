//
//  ChatModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 14.03.2026.
//

import Foundation

struct ChatModel: Identifiable, Hashable, Equatable {
    let threadID: String
    let personName: String
    let personType: ConnectionType
    let tips: InitialModel?
    
    struct InitialModel: Hashable {
        let insight: String
        let tips: [String]
    }
    
    var id: String { threadID }
}

extension ChatModel {
    init(model: InsightModel) {
        threadID = model.id
        personName = model.personName
        personType = model.connectionType
        tips = nil
    }
}
