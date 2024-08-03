//
//  MainView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 02.07.2024..
//

import SwiftUI

struct MainView: View {
    @Binding var showSignInView: Bool

    var body: some View {
        TabView {
            NavigationView {
                TransactionsView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "list.clipboard")
                        .foregroundColor(Color("SecondaryColor"))
                    Text("Transactions")
                        .foregroundColor(Color("SecondaryColor"))
                }
            }

            NavigationView {
                BudgetsView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "bag")
                        .foregroundColor(Color("SecondaryColor"))
                    Text("Budgets")
                        .foregroundColor(Color("SecondaryColor"))
                }
            }

            NavigationView {
                AccountsView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "creditcard")
                        .foregroundColor(Color("SecondaryColor"))
                    Text("Accounts")
                        .foregroundColor(Color("SecondaryColor"))
                    
                }
            }

            NavigationView {
                SettingsView(showSignInView: $showSignInView)
            }
            .tabItem {
                VStack {
                    Image(systemName: "gear")
                        .foregroundColor(Color("SecondaryColor"))
                    Text("Settings")
                        .foregroundColor(Color("SecondaryColor"))
                }
            }
        }
        .accentColor(Color("AccentColor"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showSignInView: .constant(false))
    }
}

