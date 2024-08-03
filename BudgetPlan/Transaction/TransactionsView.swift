// TransactionsView.swift
// BudgetPlan
//
// Kreirao Tamara Barišić 02.07.2024.
//

import SwiftUI

struct TransactionsView: View {
    @StateObject private var viewModel = TransactionViewModel()
    private let transactionManager = TransactionManager()
    @State private var transactions: [TransactionViewModel] = []
    @State private var lastUpdated: Date?

    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Spacer()
                        if let lastUpdated = lastUpdated {
                            Text("Last sync: \(timeFormatter.string(from: lastUpdated))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    ForEach(transactions, id: \.id) { transaction in
                        TransactionCardView(transaction: transaction)
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
                            refreshTransactions()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .imageScale(.large)
                        }
                        Button(action: {
                                           addTransaction()
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
        }
    }

    private func sortAllTransactions() {
        // Ovdje implementirajte logiku za sortiranje
        transactions.sort { $0.amount < $1.amount }
    }

    private func loadTransactions() {
        transactionManager.getTransactionsForUser { transactions in
            DispatchQueue.main.async {
                self.transactions = transactions
                self.lastUpdated = Date()
            }
        }
    }

    private func refreshTransactions() {
        loadTransactions()
    }
    
    private func addTransaction() {
        // Ovdje implementirajte logiku za dodavanje nove transakcije
        print("Add transaction")
    }
}

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm'h'"
    return formatter
}()
