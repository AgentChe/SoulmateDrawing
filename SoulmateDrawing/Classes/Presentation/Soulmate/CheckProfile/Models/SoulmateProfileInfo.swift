//
//  SoulmateProfileInfo.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 29.01.2026.
//

import Foundation

enum SoulmateProfileInfo: Hashable, Identifiable {
    case date(String)
    case place(String)
    case time(String)
    
    var id: String { value }
    
    var value: String {
        switch self {
        case .date(let string), .place(let string), .time(let string):
            string
        }
    }
    
    var title: String {
        switch self {
        case .date:
            "Soulmate.Profile.Date".localized
        case .place:
            "Soulmate.Profile.Place".localized
        case .time:
            "Soulmate.Profile.Time".localized
        }
    }
}
