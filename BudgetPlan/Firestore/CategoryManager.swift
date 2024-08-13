//
//  CategoryManager.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 08.08.2024..
//

import Foundation
import FirebaseFirestore

class CategoryManager {
    private let db = Firestore.firestore()

    func getAllCategories(completion: @escaping ([CategoryViewModel]?, Error?) -> Void) {
        db.collection("categories").getDocuments { (querySnapshot, error) in
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

    func addCategory(_ category: CategoryViewModel, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "name": category.name,
            "icon": category.icon
        ]

        db.collection("categories").addDocument(data: data) { error in
            completion(error)
        }
    }
    
    func updateCategory(category: CategoryViewModel, completion: @escaping (Error?) -> Void) {
        let docID = category.id

        do {
            try db.collection("categories").document(docID).setData(from: category) { error in
                completion(error)
            }
        } catch let error {
            completion(error)
        }
    }
}

