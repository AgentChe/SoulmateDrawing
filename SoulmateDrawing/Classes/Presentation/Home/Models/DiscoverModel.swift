//
//  DiscoverModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 05.01.2026.
//

import Foundation

struct DiscoverModel: Codable {
    let sign: URL?
    let mainPoints: [MainPoint]
    let charts: [Chart]
    
    enum CodingKeys: String, CodingKey {
        case sign
        case mainPoints = "main_points"
        case charts
    }
}

struct MainPoint: Hashable {
    let iconURL: URL?
    let label: String
}
extension MainPoint: Codable {
    enum CodingKeys: String, CodingKey {
        case iconURL = "icon_url"
        case label
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.iconURL = try? container.decode(URL.self, forKey: .iconURL)
        self.label = try container.decode(String.self, forKey: .label)
    }
}

struct Chart: Hashable {
    let sign: String
    let label: String
    let icon: URL?
    let house: Int
    let description: String
}

extension Chart: Codable {
    enum CodingKeys: CodingKey {
        case sign
        case label
        case icon
        case house
        case description
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sign = try container.decode(String.self, forKey: .sign)
        self.label = try container.decode(String.self, forKey: .label)
        self.icon = try? container.decode(URL.self, forKey: .icon)
        self.house = try container.decode(Int.self, forKey: .house)
        self.description = try container.decode(String.self, forKey: .description)
    }
}
