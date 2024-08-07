// CategoryViewModel.swift
// BudgetPlan
//
// Kreirao Tamara Barišić 05.08.2024.
//

import Foundation

struct CategoryViewModel: Identifiable , Equatable{
    let id = UUID()
    let name: String
    let icon: String

    static func getCategories() -> [CategoryViewModel] {
        return [
            CategoryViewModel(name: "Food", icon: "🍔"),
            CategoryViewModel(name: "Transport", icon: "🚗"),
            CategoryViewModel(name: "Shopping", icon: "🛍️"),
            CategoryViewModel(name: "Health", icon: "💊"),
            CategoryViewModel(name: "Entertainment", icon: "🎬"),
            CategoryViewModel(name: "Travel", icon: "✈️"),
            CategoryViewModel(name: "Bills", icon: "💸"),
            CategoryViewModel(name: "Fitness", icon: "🏋️‍♂️"),
            CategoryViewModel(name: "Education", icon: "📚"),
            CategoryViewModel(name: "Gifts", icon: "🎁"),
            CategoryViewModel(name: "Pets", icon: "🐶")
        ]
    }
}
