//
//  ProfileSection.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 29.01.2026.
//

import Foundation

struct ProfileSection: Hashable, Identifiable {
    let id: String
    let title: String
    let items: [Model]
    
    enum Model: Hashable, Identifiable {
        case date(String?)
        case place(String?)
        case time(String?)
        case privacyPolicy
        case termOfUse
        case contactUs
        
        var id: String {
            switch self {
            case .date(let string):
                string ?? "date"
            case .place(let string):
                string ?? "place"
            case .time(let string):
                string ?? "time"
            case .privacyPolicy:
                "privacyPolicy"
            case .termOfUse:
                "termOfUse"
            case .contactUs:
                "contactUs"
            }
        }
        
        var title: String {
            switch self {
            case .date:
                "Profile.Date".localized
            case .place:
                "Profile.Place".localized
            case .time:
                "Profile.Time".localized
            case .privacyPolicy:
                "Profile.PrivacyPolicy".localized
            case .termOfUse:
                "Profile.TermsOfUse".localized
            case .contactUs:
                "Profile.Contact".localized
            }
        }
        
        var value: String? {
            switch self {
            case .date(let string), .place(let string), .time(let string):
                string
            case .privacyPolicy, .termOfUse, .contactUs:
                nil
            }
        }
    }
}
