// CategoryViewModel.swift
// BudgetPlan
//
// Kreirao Tamara Barišić 05.08.2024.
//

import Foundation

struct CategoryViewModel: Identifiable, Equatable,Encodable, Decodable {
    let id: String
    let name: String
    let icon: String
    var budgetId: String?

    init(id: String = UUID().uuidString, name: String, icon: String, budgetId: String? = nil) {
        self.id = id
        self.name = name
        self.icon = icon
        self.budgetId = budgetId
    }
}

