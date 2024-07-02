//
//  SettingsView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 02.07.2024..
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List{
            if let user = viewModel.user{
                Text("User Id: \(user.userId)")
                Text("Email: \(user.email)")
            }
            
            Button("Log out"){
                Task{
                    do{
                        try viewModel.signOut()
                        showSignInView = true;
                    }
                    catch{
                        print("Error: \(error)")
                        
                    }
                }
            }
        }
        .task{
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
    }
}

struct SettingsView_Previews: PreviewProvider{
    static var previews: some View {
        NavigationStack{
            SettingsView(showSignInView: .constant(false))
        }
    }
}
