//
//  SignUpViewModel.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 19.08.2024..
//

import Foundation
import FirebaseAuth
import FirebaseStorage

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var errorMessage: String?
    @Published var signUpSuccess: Bool = false

    func signUp(with imageData: Data?) async throws {
        errorMessage = nil
        
        guard validateInput() else {
            return
        }
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            var photoUrl: URL? = nil
            if let imageData = imageData {
                photoUrl = try await uploadImageToFirebase(imageData: imageData, uid: authResult.user.uid)
            }
            
            let authData = UserAuthData(uid: authResult.user.uid, email: authResult.user.email, photoUrl: photoUrl, firstName: firstName, lastName: lastName)
            
            try await UserManager.shared.createNewUser(auth: authData)
            
            print("User successfully registered and saved to Firestore: \(authResult.user.uid)")
            self.signUpSuccess = true
            
        } catch {
            self.errorMessage = error.localizedDescription
            throw error
        }
    }
    
    private func uploadImageToFirebase(imageData: Data, uid: String) async throws -> URL? {
        let storageRef = Storage.storage().reference().child("profile_images/\(uid).jpg")
        _ = try await storageRef.putDataAsync(imageData, metadata: nil)
        let url = try await storageRef.downloadURL()
        return url
    }
    
    private func validateInput() -> Bool {
        guard !firstName.isEmpty else {
            errorMessage = "First name cannot be empty."
            return false
        }
        
        guard !lastName.isEmpty else {
            errorMessage = "Last name cannot be empty."
            return false
        }
        
        guard !email.isEmpty else {
            errorMessage = "Email cannot be empty."
            return false
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty."
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }
        
        return true
    }
}


struct UserAuthData {
    let uid: String
    let email: String?
    let photoUrl: URL?
    let firstName: String?
    let lastName: String?
}





