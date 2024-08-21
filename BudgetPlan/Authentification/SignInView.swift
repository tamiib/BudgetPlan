//
//  SignInEmailView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 30.05.2024..
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    private var darkBrownColor: Color {
        Color("DarkBrownColor")
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                    .padding(.top, 50)
                            
                Text("BudgetPlan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
                    .foregroundColor(darkBrownColor)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(darkBrownColor)
                    TextField("", text: $viewModel.email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(darkBrownColor, lineWidth: 1)
                        )
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                .padding(.horizontal, 15)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                        .font(.headline)
                        .foregroundColor(darkBrownColor)
                    SecureField("", text: $viewModel.password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(darkBrownColor, lineWidth: 1)
                        )
                }
                .padding(.bottom, 12)
                .padding(.horizontal, 15)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)
                }

                Button {
                    Task {
                        do {
                            let signInSuccess = try await viewModel.signIn()
                            if signInSuccess {
                                DispatchQueue.main.async {
                                    showSignInView = false
                                }
                            }
                        } catch {
                            print("Sign in failed with error: \(error)")
                        }
                    }
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(darkBrownColor)
                        .cornerRadius(10)
                        .padding(.horizontal, 15)
                }
                
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: SignUpView(showSignInView: $showSignInView)) { 
                        Text("Sign up")
                            .fontWeight(.bold)
                            .foregroundColor(darkBrownColor)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
        }
    }
}
