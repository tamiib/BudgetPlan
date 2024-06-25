//
//  AuthentificationView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 30.05.2024..
//

import SwiftUI

struct AuthentificationView: View {
    @Binding var showSignInView: Bool
    var body: some View {
        VStack{
            NavigationLink{
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}
#Preview {
    NavigationStack{
        AuthentificationView(showSignInView: .constant(false))
    }
}
