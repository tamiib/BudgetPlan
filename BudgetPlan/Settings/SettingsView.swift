//
//  SettingsView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 02.07.2024..
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            // Profile section
            ProfileView(userName: "John Doe", userEmail: "john.doe@gmail.com", userImage: Image("userProfileImage"))
                .padding(.horizontal)
        
            AccountsView()
            
            Spacer()
            
            Button(action: {
                showSignInView = true
            }) {
                Text("Log out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkBrownColor"))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .padding(.top)
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}

