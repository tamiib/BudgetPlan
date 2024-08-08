//
//  BudgetViewModel.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 08.08.2024..
//

import Foundation
import FirebaseFirestoreSwift

struct BudgetsViewModel: Identifiable, Equatable, Encodable, Decodable {
    let id: UUID
    let name: String
    let categoryName: String
    let categoryIcon: String
    let amount: Double
    let leftAmount: Double
    let expense: Bool
    let currency: String

    var idString: String {
        return id.uuidString
    }
}

