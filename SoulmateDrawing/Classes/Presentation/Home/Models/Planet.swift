//
//  Planet.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 20.12.2025.
//

import Foundation

enum Planet: String, Codable {
    case jupiter = "Jupiter"
    case mars = "Mars"
    case mercury = "Mercury"
    case moon = "Moon"
    case neptune = "Neptune"
    case pluto = "Pluto"
    case rising = "Rising"
    case saturn = "Saturn"
    case sun = "Sun"
    case venus = "Venus"
}

extension Planet {
    var iconName: String {
        switch self {
        case .jupiter:
            "planetJupiter"
        case .mars:
            "planetMars"
        case .mercury:
            "planetMercury"
        case .moon:
            "planetMoon"
        case .neptune:
            "planetNeptune"
        case .pluto:
            "planetPluto"
        case .rising:
            "planetRising"
        case .saturn:
            "planetSaturn"
        case .sun:
            "planetSun"
        case .venus:
            "planetVenus"
        }
    }
    
    var name: String {
        switch self {
        case .jupiter:
            "Jupiter".localized
        case .mars:
            "Mars".localized
        case .mercury:
            "Mercury".localized
        case .moon:
            "Moon".localized
        case .neptune:
            "Neptune".localized
        case .pluto:
            "Pluto".localized
        case .rising:
            "Rising".localized
        case .saturn:
            "Saturn".localized
        case .sun:
            "Sun".localized
        case .venus:
            "Venus".localized
        }
    }
}
