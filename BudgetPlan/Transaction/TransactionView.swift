import SwiftUI

struct TransactionView: View {
    @StateObject private var viewModel = TransactionViewModel()
    private let transactionManager = TransactionManager()
    @State private var transactions: [TransactionViewModel] = []
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Transactions")
                
                ForEach(transactions, id: \.id) { transaction in
                    VStack(alignment: .leading) {
                        Text("ID: \(transaction.id)")
                        Text("Amount: \(transaction.amount, specifier: "%.2f")")
                        Text("Description: \(transaction.description)")
                        Text("Bank Account Name: \(transaction.bankAccountName)")
                        Text("Created: \(transaction.created, formatter: dateFormatter)")
                        Text("Category: \(transaction.category)")
                        Text("Expense: \(transaction.expense ? "True" : "False")")
                    }
                    .padding()
                }
            }
            .onAppear {
                transactionManager.getTransactionsForUser { transactions in
                    self.transactions = transactions
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack(spacing: 20) {
                        VStack {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.gray)
                            Text("Transactions")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Image(systemName: "dollarsign.square")
                                .foregroundColor(.gray)
                            Text("Budgets")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.gray)
                            Text("Accounts")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Image(systemName: "gearshape")
                                .foregroundColor(.gray)
                            Text("Settings")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemBackground))
                    .shadow(radius: 1)
                }
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(showSignInView: .constant(false))
    }
}
