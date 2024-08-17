//
//  AccountManager.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 09.08.2024..
//

import Foundation
import FirebaseFirestore

class AccountManager {
    private let db = Firestore.firestore()
    private let collectionName = "accounts"
    
    func getAllAccounts(completion: @escaping ([AccountViewModel]?, Error?) -> Void) {
        db.collection(collectionName).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                var accounts: [AccountViewModel] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let accountName = data["accountName"] as? String ?? ""
                    let accountNumber = data["accountNumber"] as? String ?? ""
                    let group = data["group"] as? Bool ?? false
                    let account = AccountViewModel(id: id, accountName: accountName, accountNumber: accountNumber, group: group)
                    accounts.append(account)
                }
                completion(accounts, nil)
            }
        }
    }
    
    func addAccount(_ account: AccountViewModel, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "accountName": account.accountName,
            "accountNumber": account.accountNumber,
            "group": account.group
        ]

        db.collection(collectionName).addDocument(data: data) { error in
            completion(error)
        }
    }
    
    func deleteAccount(_ accountId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collectionName).document(accountId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
