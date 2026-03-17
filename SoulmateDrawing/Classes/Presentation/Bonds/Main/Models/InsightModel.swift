//
//  InsightModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 16.03.2026.
//

import Foundation

struct InsightModel: Identifiable, Hashable {
    let id: String
    let formattedDate: String
    let text: String
    let connectionType: ConnectionType
    let personName: String
    
    var pairText: String {
        "Bonds.You".localized + " & " + personName
    }
}

extension InsightModel {
    init(response: ChatHistoryResponse.Item) {
        self.id = response.threadId
        self.formattedDate = SmartDateStyle().format(response.createdDate)
        self.text = response.message.content
        self.connectionType = response.petsonType
        self.personName = response.personName
    }
}
