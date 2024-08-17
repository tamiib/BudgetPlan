//
//  TransactionViewModel.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 26.06.2024..
//

import Foundation


struct TransactionViewModel:  Identifiable, Encodable, Decodable {
    let id: String
    var amount: Double
    var description: String
    var bankAccountName: String
    var created: Date
    var categoryName: String
    var expense: Bool
    var currency: String
    var sorted: Bool
    var categoryIcon: String

    init(id: String = UUID().uuidString, amount: Double = 0.0, description: String = "", bankAccountName: String = "", created: Date = Date(), categoryName: String = "", expense: Bool = true, currency: String = "", sorted: Bool = false, categoryIcon: String = "") {
        self.id = id
        self.amount = amount
        self.description = description
        self.bankAccountName = bankAccountName
        self.created = created
        self.categoryName = categoryName
        self.expense = expense
        self.currency = currency
        self.sorted = sorted
        self.categoryIcon = categoryIcon
    }
}


