//
//  SettingsView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 30.05.2024..
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    func signOut() throws {
          try AuthenticationManager.shared.signOut()
    }
}
struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List{
            Button("Log out"){
                Task(){
                    do{
                        try viewModel.signOut()
                        showSignInView=true
                    }catch{
                        print("Error: \(error)")
                    }
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
