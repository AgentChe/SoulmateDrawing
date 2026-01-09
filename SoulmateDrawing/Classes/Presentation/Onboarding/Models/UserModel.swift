//
//  UserModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 18.12.2025.
//

import Foundation

struct UserModel: Decodable {
    var name: String
    var bornDate: Date
    var city: String
    
    init(name: String, bornDate: Date, city: String) {
        self.name = name
        self.bornDate = bornDate
        self.city = city
    }
}
