//
//  ProfileView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 23.06.2024..
//

import SwiftUI
@MainActor
final class ProfileViewModel: ObservableObject{
    
    @Published private(set) var user: DBUser? = nil
    
    
    func loadCurrentUser() async  throws {
        let authDataResult =  try  AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func signOut() throws{
      try  AuthenticationManager.shared.signOut()
    }
}

struct ProfileView: View {
    
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
        .toolbar {
            ToolbarItem (placement: .navigationBarTrailing){
                NavigationLink{
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider{
    static var previews: some View {
        NavigationStack{
            ProfileView(showSignInView: .constant(false))
        }
    }
}
