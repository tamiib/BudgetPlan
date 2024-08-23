// TransactionsView.swift
// BudgetPlan
//
// Kreirao Tamara Barišić 02.07.2024.
//
import SwiftUI

struct TransactionsView: View {
    @State private var viewModel = TransactionViewModel()
    private let transactionManager = TransactionManager()
    private let categoryManager = CategoryManager()
    private let budgetManager = BudgetManager() // Dodano
    @State private var transactions: [TransactionViewModel] = []
    @State private var lastUpdated: Date?
    @State private var selectedTab: Tab = .unsorted
    @State private var selectedTransaction: TransactionViewModel?
    @State private var selectedCategory: CategoryViewModel?
    @State private var isAddTransactionPresented: Bool = false
    @State private var isSorting: Bool = false

    enum Tab: String, CaseIterable {
        case unsorted = "Unsorted"
        case sorted = "Sorted"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Transactions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    loadTransactions()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.large)
                }
                Button(action: {
                    isAddTransactionPresented = true
                }) {
                    Image(systemName: "plus")
                        .imageScale(.medium)
                        .padding(5)
                        .background(Color("AccentColor"))
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 20)

            HStack {
                Spacer()
                if let lastUpdated = lastUpdated {
                    Text("Last sync: \(Helper.timeFormatter(for: lastUpdated))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 15)

            Picker("Select Transactions", selection: $selectedTab) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom, 10)

            if isSorting {
                ProgressView("Sorting transactions...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(filteredTransactions, id: \.id) { transaction in
                            TransactionCardView(transaction: transaction, backgroundColorName: "White")
                                .onTapGesture {
                                    if (!transaction.sorted) {
                                        self.selectedTransaction = transaction
                                    }
                                }
                        }
                    }
                }
            }

            Spacer()

            Button(action: {
                sortAllTransactions()
            }) {
                Text("Sort them all")
                    .font(.headline)
                    .padding(.horizontal, 120)
                    .padding(.vertical, 15)
                    .background(Color("DarkBrownColor"))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .onAppear {
            loadTransactions()
        }
        .sheet(isPresented: $isAddTransactionPresented) {
            AddTransactionSheet(isPresented: $isAddTransactionPresented, onSave: { newTransaction in
                transactions.append(newTransaction)
            })
        }
        .sheet(item: $selectedTransaction, onDismiss: {
            selectedTransaction = nil
            loadTransactions()
        }) { transaction in
            TransactionDetailSheet(transaction: transaction, selectedCategory: $selectedCategory)
        }
    }

    private var filteredTransactions: [TransactionViewModel] {
        switch selectedTab {
        case .unsorted:
            return transactions.filter { !$0.sorted }
        case .sorted:
            return transactions.filter { $0.sorted }
        }
    }

    private func sortAllTransactions() {
        isSorting = true
        categoryManager.getAllCategories { categories, error in
            if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    isSorting = false
                }
                return
            }
            
            guard let categories = categories else {
                print("No categories found.")
                DispatchQueue.main.async {
                    isSorting = false
                }
                return
            }
            
            let dispatchGroup = DispatchGroup()
            var hasUpdates = false
            
            for i in transactions.indices {
                var transaction = transactions[i]
                let words = transaction.description
                    .split(separator: " ")
                    .map { String($0).lowercased() }
                var matchedCategory: CategoryViewModel? = nil
                
                for category in categories {
                    if words.contains(category.name.lowercased()) {
                        matchedCategory = category
                        break
                    }
                }
                
                if let matchedCategory = matchedCategory {
                    dispatchGroup.enter()
                    updateBudgetForCategory(matchedCategory, transactionAmount: transaction.amount) { success in
                        if success {
                            transaction.categoryName = matchedCategory.name
                            transaction.categoryIcon = matchedCategory.icon
                            transaction.sorted = true
                            hasUpdates = true
                            
                            self.transactionManager.updateTransaction(transaction) { error in
                                if let error = error {
                                    print("Error updating transaction \(transaction.id): \(error.localizedDescription)")
                                } else {
                                    DispatchQueue.main.async {
                                        self.transactions[i] = transaction
                                    }
                                }
                                dispatchGroup.leave()
                            }
                        } else {
                            dispatchGroup.leave()
                        }
                    }
                }
            }
            
            if hasUpdates {
                dispatchGroup.notify(queue: .main) {
                    isSorting = false
                    loadTransactions()
                }
            } else {
                DispatchQueue.main.async {
                    isSorting = false
                }
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
                    if let transaction = transactions.first(where: { $0.categoryName == category.name }) {
                        if transaction.expense {
                            budget.leftAmount -= transactionAmount
                        } else {
                            budget.leftAmount += transactionAmount
                        }
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

    private func loadTransactions() {
        transactionManager.getTransactionsForUser { transactions in
            DispatchQueue.main.async {
                self.transactions = transactions
                self.lastUpdated = Date()
            }
        }
    }
}


