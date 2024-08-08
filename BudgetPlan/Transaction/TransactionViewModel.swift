//
//  TransactionViewModel.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 26.06.2024..
//

import Foundation

@MainActor
final class TransactionViewModel: ObservableObject, Identifiable {
    let id: String
    @Published var amount: Double
    @Published var description: String
    @Published var bankAccountName: String
    @Published var created: Date
    @Published var categoryName: String
    @Published var expense: Bool
    @Published var currency: String
    @Published var sorted: Bool
    @Published var categoryIcon: String

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


