//
//  AccountViewModel.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 09.08.2024..
//

import Foundation

struct AccountViewModel: Identifiable, Equatable {
    let id: String
    let accountName: String
    let accountNumber: String
    let group: Bool

    init(id: String = UUID().uuidString, accountName: String, accountNumber: String, group: Bool) {
        self.id = id
        self.accountName = accountName
        self.accountNumber = accountNumber
        self.group = group
    }
}
