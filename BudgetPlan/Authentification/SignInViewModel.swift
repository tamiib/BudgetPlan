//
//  SignInViewModel.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 25.06.2024..
//

import Foundation
import FirebaseAuth

class SignInEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?

    func signIn() async throws -> Bool {
      
        DispatchQueue.main.async {
            self.errorMessage = nil
        }
        
        guard validateInput() else {
            return false
        }
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            print("User signed in successfully: \(authResult.user.uid)")
            return true
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
            return false
        }
    }
    
    private func validateInput() -> Bool {
        guard !email.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = "Email cannot be empty."
            }
            return false
        }
        
        guard !password.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = "Password cannot be empty."
            }
            return false
        }
        
        return true
    }
}

