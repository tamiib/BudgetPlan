//
//  AccountViewModel.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 09.08.2024..
//

import Foundation
import FirebaseAuth

struct AccountViewModel: Identifiable, Equatable {
    let id: String
    var accountName: String
    var accountNumber: String
    var group: Bool
    var userId: String

    init(id: String = UUID().uuidString, accountName: String, accountNumber: String, group: Bool) {
        self.id = id
        self.accountName = accountName
        self.accountNumber = accountNumber
        self.group = group
        self.userId = Auth.auth().currentUser?.uid ?? ""
    }
}
