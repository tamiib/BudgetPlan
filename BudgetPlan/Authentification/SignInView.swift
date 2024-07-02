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
    
    var body: some View {
        VStack{
            
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
                .padding(.top, 50)
                        
            Text("BudgetPlan")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 50)
            
            VStack(alignment: .leading, spacing:5) {
                Text("Email")
                    .font(.headline)
                    .foregroundColor(Color.gray)
                TextField("", text: $viewModel.email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 15)
            
            VStack(alignment: .leading, spacing: 5) {
                 Text("Password")
                     .font(.headline)
                     .foregroundColor(Color.gray)
                 SecureField("", text: $viewModel.password)
                     .padding()
                     .background(Color.white)
                     .cornerRadius(10)
                     .overlay(
                         RoundedRectangle(cornerRadius: 10)
                             .stroke(Color.gray, lineWidth: 1)
                     )
             }
            .padding(.bottom, 12)
            .padding(.horizontal, 15)
            
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal, 15)
                    .padding(.bottom,15)
            }

            
            Button{
                Task {
                               
                        do {
                            try await viewModel.signIn()
                                showSignInView=false
                                   return
                               } catch {
                                   print(error)
                               }
                           }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
            }
            
            HStack {
                Text("Don't have an account?")
                Button(action: {
                    viewModel.showSignUpView = true
                }) {
                    Text("Sign up")
                        .fontWeight(.bold)
                }
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .navigationDestination(isPresented: $viewModel.isSignedIn) {
                      ProfileView(showSignInView: $showSignInView)
                  }
    }
}

#Preview {
    NavigationStack {
        SignInView(showSignInView: .constant(false))
    }
}
