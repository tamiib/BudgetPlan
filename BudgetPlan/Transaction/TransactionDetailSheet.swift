// TransactionDetailSheet.swift
// BudgetPlan
//
// Kreirao Tamara Barišić 05.08.2024.
//

import SwiftUI

struct TransactionDetailSheet: View {
    @State  var transaction: TransactionViewModel
    @Binding var selectedCategory: CategoryViewModel?
    @Environment(\.presentationMode) var presentationMode
    private let transactionManager = TransactionManager()
    @State private var categories: [CategoryViewModel] = []
    private let categoryManager = CategoryManager()
    private let budgetManager = BudgetManager()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.backward")
                            Text("Back")
                                .font(.headline)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 15)

                TransactionCardView(transaction: transaction, backgroundColorName: "BackgroundColor")
                    .padding(.horizontal)

                Text("Select category")
                    .font(.headline)
                    .bold()
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                FlowLayout(categories: categories, selectedCategory: $selectedCategory, backgroundColorName: "BackgroundColor")
                    .padding(.horizontal)

                Spacer() 
                
                Button(action: {
                    if let selectedCategory = selectedCategory {
                        updateBudgetForCategory(selectedCategory, transactionAmount: transaction.amount) { success in
                            if success {
                                transaction.categoryName = selectedCategory.name
                                transaction.categoryIcon = selectedCategory.icon
                                transaction.sorted = true
                                updateTransaction(transaction) { success in
                                    if success {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        }
                    }
                }) {
                    Text("Set Category")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("AccentColor").opacity(selectedCategory != nil ? 1.0 : 0.5))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(selectedCategory == nil)
                .padding(.bottom, 20)
            }
            .onAppear(){
                fetchCategories()
            }
        }
    }
    
    private func updateTransaction(_ transaction: TransactionViewModel, completion: @escaping (Bool) -> Void) {
        transactionManager.updateTransaction(transaction) { error in
            if let error = error {
                print("Error updating transaction: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    private func fetchCategories() {
        categoryManager.getAllAssignedCategories { categories, error in
            if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
            } else {
                self.categories = categories ?? []
            }
        }
    }

    private func updateBudgetForCategory(_ category: CategoryViewModel, transactionAmount: Double, completion: @escaping (Bool) -> Void) {
        guard let budgetId = category.budgetId else {
            completion(false)
            return
        }

        budgetManager.getAllBudgets { budgets, error in
            if let error = error {
                print("Error fetching budgets: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let budgets = budgets {
                if var budget = budgets.first(where: { $0.id == budgetId }) {
                    if(transaction.expense) {
                        budget.leftAmount -= transactionAmount
                    }
                    else {
                        budget.leftAmount += transactionAmount
                    }

                    budgetManager.updateBudget(budget: budget) { error in
                        if let error = error {
                            print("Error updating budget: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
}


