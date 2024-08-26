//
//  AccountsView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 02.07.2024..
//

import SwiftUI

struct AccountsView: View {
    @State private var accounts: [AccountViewModel] = []
    @State private var accountManager = AccountManager()
    
    @State private var selectedAccount: AccountViewModel? = nil
    @State private var isNewAccount: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Accounts")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    isNewAccount = true
                    selectedAccount = AccountViewModel(id: UUID().uuidString,accountName: "", accountNumber: "", group: false)
                }) {
                    Text("Add new")
                        .foregroundColor(Color("AccentColor"))
                        .fontWeight(.bold)
                }
            }
            .padding(.bottom, 10)
            
            if accounts.isEmpty {
                Text("No accounts available.")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(accounts, id: \.id) { account in
                            AccountCardView(account: account)
                                .onTapGesture {
                                    selectedAccount = account
                                }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            loadAccounts()
        }
        .sheet(item: $selectedAccount) { account in
            AccountDetailView(account: account, isNewAccount: isNewAccount ) {
                loadAccounts()
            }
            .onDisappear {
                resetNewAccountFlag()
            }
        }
    }
    
    private func loadAccounts() {
        accountManager.getAllAccounts { accounts, error in
            if let accounts = accounts {
                self.accounts = accounts
            } else if let error = error {
                print("Error fetching accounts: \(error.localizedDescription)")
            }
        }
    }
    
    private func resetNewAccountFlag() {
        isNewAccount = false
    }
}





