//
//  AccountCardView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 11.08.2024..
//

import SwiftUI

struct AccountCardView: View {
    let account: AccountViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(account.accountName)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(account.accountNumber)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



