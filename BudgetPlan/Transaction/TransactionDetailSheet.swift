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
                VStack(spacing: 20) {
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
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .padding()
                                .background(Color(UIColor.lightGray))
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)

                    TransactionCardView(transaction: transaction)

                    Text("Select category")
                        .font(.headline)
                        .bold()
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    FlowLayout(categories: categories, selectedCategory: $selectedCategory)

                    HStack {
                        Button(action: {
                         
                        }) {
                            Text("Skip")
                                .font(.headline)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Spacer()


                        Button(action: {
                            if var selectedCategory = selectedCategory {
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
                                .background(selectedCategory != nil ? Color("DarkBrownColor"): Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(selectedCategory == nil)
                    }
                    .padding(.top, 20)
                }
                .padding()
                .background(GeometryReader { innerGeometry in
                    Color.clear
                        .preference(key: HeightPreferenceKey.self, value: innerGeometry.size.height)
                })
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(ScrollView {
                VStack {
                    Spacer(minLength: 0)
                }
            })
            .onPreferenceChange(HeightPreferenceKey.self) { height in
                if height > geometry.size.height * 0.75 {
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear(){
            fetchCategories()
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
        categoryManager.getAllCategories { categories, error in
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

struct HeightPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
