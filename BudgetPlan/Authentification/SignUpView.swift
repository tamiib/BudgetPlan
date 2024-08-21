//
//  ProfileView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 23.06.2024..
//
import SwiftUI
import PhotosUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Binding var showSignInView: Bool
    
    @State private var selectedImageData: Data? = nil
    @State private var showImagePicker = false

    private var darkBrownColor: Color {
        Color("DarkBrownColor")
    }

    var body: some View {
        VStack {
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 75)
                

            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(darkBrownColor)
                .padding(.bottom, 20)

            VStack(alignment: .center, spacing: 5) {
                Text("Select Profile Picture")
                    .font(.headline)
                    .foregroundColor(darkBrownColor)
                
                if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.bottom, 10)
                } else {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(darkBrownColor)
                            .padding()
                    }
                }
            }
            .padding(.horizontal, 15)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(imageData: $selectedImageData)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("First Name")
                    .font(.headline)
                    .foregroundColor(darkBrownColor)
                TextField("", text: $viewModel.firstName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(darkBrownColor, lineWidth: 1)
                    )
                    .autocapitalization(.words)
            }
            .padding(.horizontal, 15)

            VStack(alignment: .leading, spacing: 5) {
                Text("Last Name")
                    .font(.headline)
                    .foregroundColor(darkBrownColor)
                TextField("", text: $viewModel.lastName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(darkBrownColor, lineWidth: 1)
                    )
                    .autocapitalization(.words)
            }
            .padding(.horizontal, 15)

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
            .padding(.horizontal, 15)

            VStack(alignment: .leading, spacing: 5) {
                Text("Confirm Password")
                    .font(.headline)
                    .foregroundColor(darkBrownColor)
                SecureField("", text: $viewModel.confirmPassword)
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
                        try await viewModel.signUp(with: selectedImageData)
                        if viewModel.signUpSuccess {
                            showSignInView = false
                        }
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(darkBrownColor)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
            }

            Spacer()
        }
        .padding()
        .onChange(of: viewModel.signUpSuccess) { success in
            if success {
                showSignInView = false
            }
        }
    }
}
