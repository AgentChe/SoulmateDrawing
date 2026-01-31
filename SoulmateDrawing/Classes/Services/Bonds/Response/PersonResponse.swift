//
//  PersonResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import Foundation

struct PersonResponse: Codable {
    let id: String
    let name: String
    let singImage: URL?
}
