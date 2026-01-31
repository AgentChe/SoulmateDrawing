//
//  PersonModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.01.2026.
//

import Foundation

struct PersonModel: Hashable, Identifiable {
    let id: String
    let name: String
    let singImage: URL?
}

extension PersonModel {
    init(from response: PersonResponse) {
        self.init(id: response.id, name: response.name, singImage: response.singImage)
    }
}
