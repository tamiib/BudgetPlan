//
//  ProfileView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 23.06.2024..
//

import SwiftUI

struct ProfileView: View {
    var userName: String
    var userEmail: String
    var userImage: Image
    
    var body: some View {
        HStack(spacing: 16) {
            userImage
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(userName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(userEmail)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    ProfileView(userName: "John Doe", userEmail: "john.doe@gmail.com", userImage: Image("userProfileImage"))
}

