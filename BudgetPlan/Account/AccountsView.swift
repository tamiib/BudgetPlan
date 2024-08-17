//
//  AccountsView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 02.07.2024..
//

import SwiftUI

struct AccountsView: View {
    @State private var  accounts: [AccountViewModel] = []
    @State private var accountManager = AccountManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Accounts")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                   
                }) {
                    Text("Add new")
                        .foregroundColor(Color("AccentColor"))
                }
            }
            .padding(.horizontal)
            
            if accounts.isEmpty {
                Text("No accounts available.")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                VStack(spacing:10){
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(accounts, id: \.id) { account in
                              AccountCardView(account: account)
                                    .padding(.horizontal)
                                    .padding(.top, 5)
                            }
                        }
                    }
                }
            }
        }
        .padding(.top)
        .onAppear {
            loadAccounts()
        }
    }
    
    private func loadAccounts() {
        accountManager.getAllAccounts{ accounts, error in
            if let accounts = accounts {
                self.accounts = accounts
            } else if let error = error {
                print("Error fetching accounts: \(error.localizedDescription)")
            }
        }
    }

}



