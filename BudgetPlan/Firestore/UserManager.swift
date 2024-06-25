//
//  UserManager.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 23.06.2024..
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser{
    let userId: String
    let email: String
    let dateCreated : Date?
    let photoUrl: String?
}

final class UserManager{
    
    static let shared = UserManager()
    
    private init (){}
    
    func createNewUser(auth: AuthDataResultModel) async throws{
        
        var userData: [String:Any] = [
            "id" : auth.uid,
            "dateCrated" : Timestamp(),
            "email" : auth.email ?? ""
        ]
        
        if let email = auth.email{
            userData["email"] = email
        }
        
        if let photoUrl = auth.photoUrl{
            userData["photoUrl"] = photoUrl
        }
         try await Firestore.firestore().collection("users").document(auth.uid).setData(userData,merge: false)
    }
    
    func getUser (userId : String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        guard let data = snapshot.data(), let userId = data["id"] as? String, let email = data["email"] as? String else{
            throw URLError(.badServerResponse)
        }
        
        let dateCreated = data["dateCreated"] as? Date
        let photoUrl = data["photoUrl"] as? String
        
        return DBUser(userId: userId, email: email, dateCreated: dateCreated, photoUrl: photoUrl)
    }
}

