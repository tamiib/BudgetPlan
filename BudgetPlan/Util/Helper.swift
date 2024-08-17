//  Helper.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 17.08.2024..
//

import Foundation

struct Helper {
    
    static func getCurrencies() -> [String] {
        return ["USD", "EUR", "HRK", "GBP", "JPY"]
    }
    
    static func getCurrencySymbol(for currencyCode: String) -> String {
        switch currencyCode {
        case "USD":
            return "$"
        case "EUR":
            return "€"
        case "HRK":
            return "kn"
        case "GBP":
            return "£"
        case "JPY":
            return "¥"
        default:
            return currencyCode
        }
    }
    
    static func timeFormatter(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    static func dayFormatter(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    static func monthFormatter(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date).uppercased()
    }
}
