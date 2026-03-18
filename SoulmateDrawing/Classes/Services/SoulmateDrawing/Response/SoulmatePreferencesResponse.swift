//
//  SoulmatePreferencesResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 31.01.2026.
//

import Foundation

struct SoulmatePreferencesResponse: Decodable {
    let genders: [String]
    let ethnicities: [String]
}
