//
//  AccountManager.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 09.08.2024..
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AccountManager {
    private let db = Firestore.firestore()
    private let collectionName = "accounts"
    
    private func checkUserAuthentication(completion: @escaping (String?) -> Void) {
        if let userID = Auth.auth().currentUser?.uid {
            completion(userID)
        } else {
            completion(nil)
        }
    }
    
    func getAllAccounts(completion: @escaping ([AccountViewModel]?, Error?) -> Void) {
        checkUserAuthentication { userID in
            guard let userID = userID else {
                completion(nil, NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"]))
                return
            }
            
            self.db.collection(self.collectionName).whereField("userId", isEqualTo: userID).getDocuments { (querySnapshot, error) in
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
    }
    
    func addAccount(_ account: AccountViewModel, completion: @escaping (Error?) -> Void) {
        checkUserAuthentication { userID in
            guard let userID = userID else {
                completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"]))
                return
            }
            
            let data: [String: Any] = [
                "id": account.id,
                "accountName": account.accountName,
                "accountNumber": account.accountNumber,
                "group": account.group,
                "userId": userID
            ]

            self.db.collection(self.collectionName).addDocument(data: data) { error in
                completion(error)
            }
        }
    }
    
    func updateAccount(_ account: AccountViewModel, completion: @escaping (Error?) -> Void) {
        checkUserAuthentication { userID in
            guard let _ = userID else {
                completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"]))
                return
            }
            
            let data: [String: Any] = [
                "accountName": account.accountName,
                "accountNumber": account.accountNumber,
                "group": account.group
            ]

            self.db.collection(self.collectionName).document(account.id).updateData(data) { error in
                completion(error)
            }
        }
    }

    
    func deleteAccount(_ accountId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        checkUserAuthentication { userID in
            guard let _ = userID else {
                completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])))
                return
            }
            
            self.db.collection(self.collectionName).document(accountId).delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}

