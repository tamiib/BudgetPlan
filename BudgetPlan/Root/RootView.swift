//
//  RootView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 30.05.2024..
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView = false;
    
    var body: some View {
        ZStack{
            if !showSignInView {
                ProfileView(showSignInView: $showSignInView)
            }
        }
        .onAppear{
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView){
            NavigationStack{
                SignInView(showSignInView: .constant(false))
            }
            
        }
    }
}

#Preview {
    RootView()
}
