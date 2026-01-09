//
//  Zodiac.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 23.12.2025.
//

import Foundation

enum Zodiac: String, Decodable {
    case aquarius = "Aquarius"
    case aries = "Aries"
    case cancer = "Cancer"
    case carpicorn = "Carpicorn"
    case gemini = "Gemini"
    case leo = "Leo"
    case libra = "Libra"
    case pisces = "Pisces"
    case sagittarius = "Sagittarius"
    case scorpio = "Scorpio"
    case taurus = "Taurus"
    case virgo = "Virgo"
}

extension Zodiac {
    var smallIconName: String {
        "\(rawValue.lowercased())_small"
    }
    
    var largeIconName: String {
        "\(rawValue.lowercased())_large"
    }
    
    var name: String {
        switch self {
        case .aquarius:
            "Zodiac.Aquarius".localized
        case .aries:
            "Zodiac.Aries".localized
        case .cancer:
            "Zodiac.Cancer".localized
        case .carpicorn:
            "Zodiac.Carpicorn".localized
        case .gemini:
            "Zodiac.Gemini".localized
        case .leo:
            "Zodiac.Leo".localized
        case .libra:
            "Zodiac.Libra".localized
        case .pisces:
            "Zodiac.Pisces".localized
        case .sagittarius:
            "Zodiac.Sagittarius".localized
        case .scorpio:
            "Zodiac.Scorpio".localized
        case .taurus:
            "Zodiac.Taurus".localized
        case .virgo:
            "Zodiac.Virgo".localized
        }
    }
}
