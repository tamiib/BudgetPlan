//
//  SettingsViewModel.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 02.07.2024..
//

import Foundation
@MainActor
final class SettingsViewModel: ObservableObject{
    
    @Published private(set) var user: DBUser? = nil
    
    
    func loadCurrentUser() async  throws {
        let authDataResult =  try  AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func signOut() throws{
      try  AuthenticationManager.shared.signOut()
    }
}
