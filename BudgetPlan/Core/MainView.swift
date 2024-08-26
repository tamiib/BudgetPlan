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
                    Text("Transactions")
                }
            }

            NavigationView {
                BudgetsView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "bag")
                    Text("Budgets")
                }
            }

            NavigationView {
                CategoryView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "rectangle.grid.2x2")
                    Text("Category")
                }
            }

            NavigationView {
                SettingsView(showSignInView: $showSignInView)
            }
            .tabItem {
                VStack {
                    Image(systemName: "gear")
                    Text("Settings")
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

