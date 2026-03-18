//
//  Fonts.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 17.12.2025.
//

import SwiftUI

extension Font {
    enum Gambarino {
        static func font(size: CGFloat, weight: Weight) -> UIFont {
            UIFont(name: weight.name, size: size)!
        }
        
        static func font(size: CGFloat, weight: Weight) -> Font {
            Font(font(size: size, weight: weight))
        }
        
        enum Weight {
            case w400
            
            var name: String {
                switch self {
                case .w400:
                    "Gambarino-Regular"
                }
            }
        }
    }
    
    enum SFPro {
        static func font(size: CGFloat, weight: Weight) -> UIFont {
            UIFont(name: weight.name, size: size)!
        }
        
        static func font(size: CGFloat, weight: Weight) -> Font {
            Font(font(size: size, weight: weight))
        }
        
        enum Weight {
            case w400
            case w510
            
            var name: String {
                switch self {
                case .w400:
                    "SFProText-Regular"
                case .w510:
                    "SFProText-Medium"
                }
            }
        }
    }
}
