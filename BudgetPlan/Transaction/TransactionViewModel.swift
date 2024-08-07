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
    @Published var category: String
    @Published var expense: Bool
    @Published var currency: String
    @Published var sorted: Bool

    init(id: String = UUID().uuidString, amount: Double = 0.0, description: String = "", bankAccountName: String = "", created: Date = Date(), category: String = "", expense: Bool = true, currency: String = "", sorted: Bool = false) {
        self.id = id
        self.amount = amount
        self.description = description
        self.bankAccountName = bankAccountName
        self.created = created
        self.category = category
        self.expense = expense
        self.currency = currency
        self.sorted = sorted
    }
}


