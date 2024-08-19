//
//  BudgetManager.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 08.08.2024..
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

class BudgetManager {
    private let db = Firestore.firestore()
    private let budgetCollection = "budgets"

    private func checkUserAuthentication(completion: @escaping (String?) -> Void) {
        if let userID = Auth.auth().currentUser?.uid {
            completion(userID)
        } else {
            completion(nil)
        }
    }

    func getAllBudgets(completion: @escaping ([BudgetsViewModel]?, Error?) -> Void) {
        checkUserAuthentication { userID in
            guard let userID = userID else {
                completion(nil, NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"]))
                return
            }
            
            self.db.collection(self.budgetCollection).whereField("userId", isEqualTo: userID).getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    var budgets: [BudgetsViewModel] = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let id = data["id"] as? String ?? ""
                        let name = data["name"] as? String ?? ""
                        let categoryIds = data["categoryIds"] as? [String] ?? []
                        let amount = data["amount"] as? Double ?? 0.0
                        let leftAmount = data["leftAmount"] as? Double ?? 0.0
                        let expense = data["expense"] as? Bool ?? true
                        let currency = data["currency"] as? String ?? ""
                        let icon = data["icon"] as? String ?? ""

                        let budget = BudgetsViewModel(id: id, name: name, categoryIds: categoryIds, amount: amount, leftAmount: leftAmount, expense: expense, currency: currency, icon: icon)
                        
                        budgets.append(budget)
                    }
                    completion(budgets, nil)
                }
            }
        }
    }

    func updateBudget(budget: BudgetsViewModel, completion: @escaping (Error?) -> Void) {
        checkUserAuthentication { userID in
            guard let _ = userID else {
                completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"]))
                return
            }
            
            let docID = budget.idString

            do {
                try self.db.collection(self.budgetCollection).document(docID).setData(from: budget) { error in
                    completion(error)
                }
            } catch let error {
                completion(error)
            }
        }
    }

    func addNewBudget(budget: BudgetsViewModel, completion: @escaping (Error?) -> Void) {
        checkUserAuthentication { userID in
            guard let _ = userID else {
                completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"]))
                return
            }
            
            do {
                let document = self.db.collection(self.budgetCollection).document(budget.idString)
                try document.setData(from: budget) { error in
                    completion(error)
                }
            } catch let error {
                completion(error)
            }
        }
    }
}

