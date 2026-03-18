//
//  DreamerDetailsType.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.03.2026.
//

import Foundation

enum DreamerDetailsType: Hashable {
    case load(id: String)
    case interpret(dream: String)
}
