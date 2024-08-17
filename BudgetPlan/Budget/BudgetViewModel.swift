//
//  BudgetViewModel.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 08.08.2024..
//

import Foundation
import FirebaseFirestoreSwift


struct BudgetsViewModel: Identifiable, Equatable, Codable, Hashable {
    var id: String
    let name: String
    var categoryIds: [String]
    let amount: Double
    var leftAmount: Double
    let expense: Bool
    let currency: String
    let icon: String

    var idString: String {
        return id
    }

    init(id: String = UUID().uuidString, name: String, categoryIds: [String], amount: Double, leftAmount: Double, expense: Bool, currency: String, icon: String) {
        self.id = id
        self.name = name
        self.categoryIds = categoryIds
        self.amount = amount
        self.leftAmount = leftAmount
        self.expense = expense
        self.currency = currency
        self.icon = icon
    }
}



