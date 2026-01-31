//
//  SettingsSheet.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 30.01.2026.
//

import Foundation

enum SettingsSheet: Identifiable {
    case bornDate
    case bornTime
    case city
    
    var id: Self { self }
}
