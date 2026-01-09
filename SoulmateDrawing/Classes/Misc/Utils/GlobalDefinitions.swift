//
//  GlobalDefinitions.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.01.2026.
//

import Foundation

enum GlobalDefinitions {
    static let domain = "https://sportcards.sergeyapps.com"
    static let apiKey = "NgIOqMk0bRMKXANEd5"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "Tg0hAPk5QrHx5TwQ"
    
    static let privacyPolicy: URL = URL(string: "https://sergeyapps.com/privacy-policy")!
    static let termsOfUse: URL = URL(string: "https://sergeyapps.com/terms-of-use")!
    static let support: URL = URL(string: "https://sergeyapps.com/contact")!
    
    static let applicationTag = "SOULMATE_DRAWING"
    static let amplitudeApiKey = "17fa94a421fa4349d8b1db59c8e06fbe"
    
    enum Paygate {
        static let yearly = "yearly"
        static let weekly = "weekly"
    }
}
