//
//  BudgetSheetData.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 15.08.2024..
//

import Foundation

struct BudgetSheetData: Identifiable {
    var id: String { budget.id }
    var budget: BudgetsViewModel
    var validCategories: [CategoryViewModel]
}

