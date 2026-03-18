//
//  ProfileListResponse.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 12.03.2026.
//

import Foundation

struct ProfileListResponse: Decodable {
    let items: [PersonResponse]
    let pagination: Pagination
}
