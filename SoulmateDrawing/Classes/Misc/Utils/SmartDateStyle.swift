//
//  SmartDateStyle.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 16.03.2026.
//

import Foundation

struct SmartDateStyle: FormatStyle {
    func format(_ value: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(value) {
            return "Today".localized
        }
        
        if calendar.isDateInYesterday(value) {
            return "Yesterday".localized
        }
        
        let style = Date.FormatStyle()
            .day(.defaultDigits)
            .month(.abbreviated)
        
        return style.format(value)
    }
}
