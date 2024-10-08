//  AddTransactionSheet.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 15.08.2024..
//

import SwiftUI

struct AddTransactionSheet: View {
    @Binding var isPresented: Bool
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var selectedBankAccountName: String = "None"
    @State private var created: Date = Date()
    @State private var isExpense: Bool = true
    @State private var currency: String = Helper.getCurrencies().first ?? "EUR"
    @State private var selectedCategory: CategoryViewModel?
    @State private var categories: [CategoryViewModel] = []
    @State private var bankAccounts: [String] = []
    @State private var showAlert = false
    @State private var alertMessage = ""

    private let transactionManager = TransactionManager()
    private let categoryManager = CategoryManager()
    private let accountManager = AccountManager()
    private let budgetManager = BudgetManager()

    var onSave: (TransactionViewModel) -> Void

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Transaction Details")) {
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        TextField("Description", text: $description)
                        Picker("Account", selection: $selectedBankAccountName) {
                            Text("None").tag("None")
                            ForEach(bankAccounts, id: \.self) { account in
                                Text(account).tag(account)
                            }
                        }
                        DatePicker("Date", selection: $created, displayedComponents: .date)
                        Picker("Currency", selection: $currency) {
                            ForEach(Helper.getCurrencies(), id: \.self) {
                                Text($0)
                            }
                        }
                        Toggle(isOn: $isExpense) {
                            Text("Is Expense")
                        }
                        .tint(Color("AccentColor"))
                    }

                    Section(header: Text("Select Category")) {
                        ScrollView {
                            FlowLayout(categories: categories, selectedCategory: $selectedCategory, backgroundColorName: "BackgroundColor")
                        }
                    }
                }

                Button(action: {
                    validateAndSaveTransaction()
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("AccentColor"))
                        .cornerRadius(8)
                }
                .padding()
                .disabled(amount.isEmpty || description.isEmpty)
                .opacity(amount.isEmpty || description.isEmpty ? 0.5 : 1.0)
            }
            .navigationBarTitle("Add Transaction", displayMode: .inline)
            .navigationBarItems(leading: Button("Back") {
                isPresented = false
            })
            .onAppear {
                fetchCategories()
                fetchBankAccounts()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func validateAndSaveTransaction() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            alertMessage = "Please enter a valid amount greater than 0."
            showAlert = true
            return
        }

        let currencySymbol = Helper.getCurrencySymbol(for: currency)

        var newTransaction = TransactionViewModel(
            amount: amountValue,
            description: description,
            bankAccountName: selectedBankAccountName == "None" ? "" : selectedBankAccountName,
            created: created,
            categoryName: "",
            expense: isExpense,
            currency: currencySymbol,
            sorted: false,
            categoryIcon: ""
        )

        transactionManager.addNewTransaction(transaction: newTransaction) { error in
            if let error = error {
                alertMessage = "Error saving transaction: \(error.localizedDescription)"
                showAlert = true
                return
            }

            if let selectedCategory = selectedCategory {
                updateBudgetForCategory(selectedCategory, transactionAmount: newTransaction.amount) { success in
                    if success {
                        newTransaction.categoryName = selectedCategory.name
                        newTransaction.categoryIcon = selectedCategory.icon
                        newTransaction.sorted = true

                        transactionManager.updateTransaction(newTransaction) { error in
                            if let error = error {
                                alertMessage = "Error updating transaction: \(error.localizedDescription)"
                                showAlert = true
                            } else {
                                onSave(newTransaction)
                            }
                            isPresented = false
                        }
                    } else {
                        alertMessage = "Error updating budget."
                        showAlert = true
                        isPresented = false
                    }
                }
            } else {
                onSave(newTransaction)
                isPresented = false
            }
        }
    }

    private func fetchCategories() {
        categoryManager.getAllCategories { categories, error in
            if let error = error {
                alertMessage = "Error fetching categories: \(error.localizedDescription)"
                showAlert = true
            } else {
                self.categories = categories ?? []
            }
        }
    }

    private func fetchBankAccounts() {
        accountManager.getAllAccounts { accounts, error in
            if let error = error {
                alertMessage = "Error fetching bank accounts: \(error.localizedDescription)"
                showAlert = true
            } else {
                self.bankAccounts = accounts?.map { $0.accountName } ?? []
                if let firstAccount = bankAccounts.first {
                    selectedBankAccountName = firstAccount
                }
            }
        }
    }

    private func updateBudgetForCategory(_ category: CategoryViewModel, transactionAmount: Double, completion: @escaping (Bool) -> Void) {
        guard let budgetId = category.budgetId else {
            alertMessage = "Error: No budget associated with this category."
            showAlert = true
            completion(false)
            return
        }

        budgetManager.getAllBudgets { budgets, error in
            if let error = error {
                alertMessage = "Error fetching budgets: \(error.localizedDescription)"
                showAlert = true
                completion(false)
                return
            }

            if let budgets = budgets {
                if var budget = budgets.first(where: { $0.id == budgetId }) {
                    if isExpense {
                        budget.leftAmount -= transactionAmount
                    } else {
                        budget.leftAmount += transactionAmount
                    }

                    budgetManager.updateBudget(budget: budget) { error in
                        if let error = error {
                            alertMessage = "Error updating budget: \(error.localizedDescription)"
                            showAlert = true
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    alertMessage = "Error: No matching budget found."
                    showAlert = true
                    completion(false)
                }
            } else {
                alertMessage = "Error: No budgets available."
                showAlert = true
                completion(false)
            }
        }
    }
}



