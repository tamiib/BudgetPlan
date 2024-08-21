//
//  ProfileView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 23.06.2024..
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        HStack(spacing: 16) {
            viewModel.userImage
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(viewModel.firstName) \(viewModel.lastName)")
                                  .font(.title2)
                                  .fontWeight(.bold)
                                  .foregroundColor(.black)
                
                Text(viewModel.userEmail)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical)
        .onAppear {
            viewModel.loadUserProfile()
        }
    }
}

#Preview {
    ProfileView()
}


