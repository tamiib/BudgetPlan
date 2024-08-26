//
//  RootView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 30.05.2024..
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView = false

    var body: some View {
        ZStack {
            if showSignInView {
                SignInView(showSignInView: $showSignInView)
            } else {
                MainView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            do {
                let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
                self.showSignInView = false
            } catch {
                self.showSignInView = true
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
