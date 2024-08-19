//
//  CategoryManager.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 08.08.2024..
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class CategoryManager {
    private var db = Firestore.firestore()
    private let categoryCollection = "categories"

    private func checkUserAuthentication(completion: @escaping (String?) -> Void) {
        if let userID = Auth.auth().currentUser?.uid {
            completion(userID)
        } else {
            completion(nil)
        }
    }

    func getAllCategories(completion: @escaping ([CategoryViewModel]?, Error?) -> Void) {
        checkUserAuthentication { userID in
            guard let userID = userID else {
                completion(nil, NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"]))
                return
            }
            
            self.db.collection(self.categoryCollection).whereField("userId", isEqualTo: userID).getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    var categories: [CategoryViewModel] = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let id = data["id"] as? String ?? ""
                        let name = data["name"] as? String ?? ""
                        let icon = data["icon"] as? String ?? ""
                        let budgetId = data["budgetId"] as? String ?? ""
                        let category = CategoryViewModel(id: id, name: name, icon: icon, budgetId: budgetId)
                        categories.append(category)
                    }
                    completion(categories, nil)
                }
            }
        }
    }

    func addCategory(category: CategoryViewModel, completion: @escaping (Error?) -> Void) {
        checkUserAuthentication { userID in
            guard let _ = userID else {
                completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"]))
                return
            }
            
            do {
                let document = self.db.collection(self.categoryCollection).document(category.id)
                
                try document.setData(from: category) { error in
                    completion(error)
                }
            } catch let error {
                completion(error)
            }
        }
    }
    
    func updateCategory(category: CategoryViewModel, completion: @escaping (Error?) -> Void) {
        checkUserAuthentication { userID in
            guard let _ = userID else {
                completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"]))
                return
            }
            
            let docID = category.id

            do {
                try self.db.collection(self.categoryCollection).document(docID).setData(from: category) { error in
                    completion(error)
                }
            } catch let error {
                completion(error)
            }
        }
    }
}

