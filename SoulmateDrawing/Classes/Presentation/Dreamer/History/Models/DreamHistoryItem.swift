//
//  DreamHistoryItem.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.03.2026.
//

import Foundation

struct DreamHistoryItem: Hashable, Identifiable {
    let id: String
    let date: String
    let text: String
    let image: URL
}
