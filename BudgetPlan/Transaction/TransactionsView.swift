// TransactionsView.swift
// BudgetPlan
//
// Kreirao Tamara Barišić 02.07.2024.
//

import SwiftUI

struct TransactionsView: View {
    @State private var viewModel = TransactionViewModel()
    private let transactionManager = TransactionManager()
    @State private var transactions: [TransactionViewModel] = []
    @State private var lastUpdated: Date?
    @State private var selectedTab: Tab = .unsorted
    @State private var selectedTransaction: TransactionViewModel?
    @State private var selectedCategory: CategoryViewModel?
    @State private var isAddTransactionPresented: Bool = false
   

    enum Tab: String, CaseIterable {
        case unsorted = "Unsorted"
        case sorted = "Sorted"
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Spacer()
                        if let lastUpdated = lastUpdated {
                            Text("Last sync: \(Helper.timeFormatter(for: lastUpdated))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    Picker("Select Transactions", selection: $selectedTab) {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom, 10)

                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(filteredTransactions, id: \.id) { transaction in
                                TransactionCardView(transaction: transaction)
                                    .onTapGesture {
                                        if(!transaction.sorted)
                                        {
                                            self.selectedTransaction = transaction
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
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Transakcije")
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
                            isAddTransactionPresented = true;
                        }) {
                            Image(systemName: "plus")
                                .imageScale(.medium)
                                .padding(5)
                                .background(Color("AccentColor"))
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                    }.padding(.top, 50)
                }
            }
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
        transactions = transactions.map { var t = $0; t.sorted = true; return t }
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

