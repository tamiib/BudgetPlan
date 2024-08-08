// CategoryViewModel.swift
// BudgetPlan
//
// Kreirao Tamara Barišić 05.08.2024.
//

import Foundation

struct CategoryViewModel: Identifiable, Equatable {
    let id: UUID
    let name: String
    let icon: String

    init(id: UUID = UUID(), name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}
