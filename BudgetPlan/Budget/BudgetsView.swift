//
//  BudgetsView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 02.07.2024..
//

import SwiftUI
import FirebaseFirestore

struct BudgetsView: View {
    @State private var budgets: [BudgetsViewModel] = []
    @State private var selectedTab: Bool = true // true for expenses, false for incomes
    @State private var budgetManager = BudgetManager()

    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Picker("Budgets", selection: $selectedTab) {
                        Text("Expenses").tag(true)
                        Text("Incomes").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    ScrollView {
                        VStack {
                            ForEach(filteredBudgets) { budget in
                                BudgetCardView(budget: budget)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text("Budgets")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                            
                            Button(action: {
                                addBudget()
                            }) {
                                Image(systemName: "plus")
                                    .imageScale(.medium)
                                    .padding(5)
                                    .background(Color("AccentColor"))
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            }
                        }.padding(.top, 50)
                    }
               
            }
                .onAppear {
                    loadBudgets()
                }
        }
    }
        

    private var filteredBudgets: [BudgetsViewModel] {
        budgets.filter { $0.expense == selectedTab }
    }

    private func loadBudgets() {
        budgetManager.getAllBudgets { budgets, error in
            if let budgets = budgets {
                self.budgets = budgets
            } else if let error = error {
                print("Error fetching budgets: \(error.localizedDescription)")
            }
        }
    }

    private func addBudget() {
        // Implementacija za dodavanje budžeta
    }
}



