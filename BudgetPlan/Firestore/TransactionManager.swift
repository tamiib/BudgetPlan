//
//  TransactionManager.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 26.06.2024..
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class TransactionManager {
    private var db = Firestore.firestore()

    func getTransactionsForUser(completion: @escaping ([TransactionViewModel]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No authenticated user")
            completion([])
            return
        }

        db.collection("transactions")
            .whereField("userId", isEqualTo: userID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting transactions: \(error.localizedDescription)")
                    completion([])
                    return
                }

                var transactions: [TransactionViewModel] = []

                for document in querySnapshot?.documents ?? [] {
                    let data = document.data()
                    let transaction = TransactionViewModel(
                        id: document.documentID,
                        amount: data["amount"] as? Double ?? 0.0,
                        description: data["description"] as? String ?? "",
                        bankAccountName: data["bankAccountName"] as? String ?? "",
                        created: (data["created"] as? Timestamp)?.dateValue() ?? Date(),
                        categoryName: data["categoryName"] as? String ?? "",
                        expense: data["expense"] as? Bool ?? true,
                        currency: data["currency"] as? String ?? "",
                        sorted: data["sorted"] as? Bool ?? false,
                        categoryIcon: data["categoryIcon"] as? String ?? ""
                    )
                    transactions.append(transaction)
                }

                completion(transactions)
            }
    }

    func updateTransaction(_ transaction: TransactionViewModel, completion: @escaping (Error?) -> Void) {
        Task {
            await MainActor.run {
                guard let userID = Auth.auth().currentUser?.uid else {
                    print("No authenticated user")
                    completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"]))
                    return
                }

                let transactionData: [String: Any] = [
                    "amount": transaction.amount,
                    "description": transaction.description,
                    "bankAccountName": transaction.bankAccountName,
                    "created": transaction.created,
                    "categoryName": transaction.categoryName,
                    "expense": transaction.expense,
                    "currency": transaction.currency,
                    "sorted": transaction.sorted,
                    "userId": userID,
                    "categoryIcon": transaction.categoryIcon
                ]

                db.collection("transactions").document(transaction.id).updateData(transactionData) { error in
                    completion(error)
                }
            }
        }
    }
}



