//
//  AccountDetailView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 21.08.2024..
//

import SwiftUI

struct AccountDetailView: View {
    @State var account: AccountViewModel
    var isNewAccount: Bool
    var onSave: () -> Void
    
    @State private var accountManager = AccountManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Details")) {
                    TextField("Account Name", text: $account.accountName)
                    TextField("Account Number", text: $account.accountNumber)
                    Toggle("Group Account", isOn: $account.group)
                        .tint(Color("AccentColor"))
                }
            }
            .navigationTitle(isNewAccount ? "New Account" : "Edit Account")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                saveAccount()
            })
        }
    }
    
    private func saveAccount() {
        if isNewAccount {
            accountManager.addAccount(account) { error in
                if let error = error {
                    print("Error saving account: \(error.localizedDescription)")
                } else {
                    onSave()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } else {
            accountManager.updateAccount(account) { error in
                if let error = error {
                    print("Error updating account: \(error.localizedDescription)")
                } else {
                    onSave()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

#Preview {
    AccountDetailView(
        account: AccountViewModel(accountName: "Sample Account", accountNumber: "123456789", group: false),
        isNewAccount: true,
        onSave: {}
    )
}
