//
//  GenderModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.01.2026.
//

import Foundation

enum GenderModel: String, CaseIterable {
    case female
    case male
    
    var name: String {
        switch self {
        case .female:
            "NewPerson.Female".localized
        case .male:
            "NewPerson.Male".localized
        }
    }
}
