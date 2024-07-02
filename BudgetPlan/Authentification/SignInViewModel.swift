//
//  SignInViewModel.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 25.06.2024..
//

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var isSignedIn = false
    @Published var showSignUpView = false
    @Published var errorMessage: String? = nil
        
    
    func signUp() async throws{
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            errorMessage = "Please enter both email and password."
            return
        }
        do {
               try await AuthenticationManager.shared.createUser(email: email, password: password)
               errorMessage = nil
           } catch {
               errorMessage = "Sign up failed. Please try again."
               throw error
           }
    }
    
    func signIn() async throws {
            guard !email.isEmpty, !password.isEmpty else {
                print("No email or password found.")
                errorMessage = "Please enter both email and password."
                return
            }
            do {
                try await AuthenticationManager.shared.signInUser(email: email, password: password)
                self.isSignedIn = true
                errorMessage = nil
            } catch {
                errorMessage = "Invalid email or password. Please try again."
                throw error
            }
        }
}
