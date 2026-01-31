//
//  NewPersonSheet.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.01.2026.
//

import Foundation

enum NewPersonSheet: Identifiable {
    case bornDate
    case bornTime
    case city
    
    var id: Self { self }
}
