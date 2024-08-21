//
//  UserManager.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 23.06.2024..
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser {
    let userId: String
    let email: String
    let dateCreated: Date?
    let photoUrl: String?
    let firstName: String?
    let lastName: String?
}

final class UserManager {
    
    static let shared = UserManager()
    private let userCollection = "users"
    
    private init() {}
    
    func createNewUser(auth: UserAuthData) async throws {
        
        var userData: [String: Any] = [
            "id": auth.uid,
            "dateCreated": Timestamp(),
            "email": auth.email ?? ""
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        if let photoUrl = auth.photoUrl {
            userData["photoUrl"] = photoUrl.absoluteString
        }
        
        if let firstName = auth.firstName {
            userData["firstName"] = firstName
        }
        
        if let lastName = auth.lastName {
            userData["lastName"] = lastName
        }
        
        try await Firestore.firestore().collection(userCollection).document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection(userCollection).document(userId).getDocument()
        guard let data = snapshot.data(),
              let userId = data["id"] as? String,
              let email = data["email"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let dateCreated = (data["dateCreated"] as? Timestamp)?.dateValue()
        let photoUrl = data["photoUrl"] as? String
        let firstName = data["firstName"] as? String
        let lastName = data["lastName"] as? String
        
        return DBUser(
            userId: userId,
            email: email,
            dateCreated: dateCreated,
            photoUrl: photoUrl,
            firstName: firstName,
            lastName: lastName
        )
    }
}



