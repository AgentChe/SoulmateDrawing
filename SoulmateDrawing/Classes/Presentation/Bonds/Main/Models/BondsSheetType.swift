//
//  BondsSheetType.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 20.01.2026.
//

import Foundation

enum BondsSheetType: Identifiable {
    case persons
    case createPerson
    case connectionType
    
    var id: Self { self }
}
