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
    @State private var categories: [CategoryViewModel] = [] // Dodano za praćenje kategorija
    @State private var selectedTab: Bool = true
    @State private var budgetManager = BudgetManager()
    @State private var categoryManager = CategoryManager()
    @State private var showingNewBudgetForm = false
    @State private var currentExpense: Bool = true // State za praćenje trenutnog expense statusa

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
                    .onChange(of: selectedTab) { newValue in
                        currentExpense = newValue // Ažuriraj currentExpense prema odabranom tabu
                    }
                    
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
                            showingNewBudgetForm.toggle()
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
                loadCategories()
            }
            .sheet(isPresented: $showingNewBudgetForm) {
                NewBudgetFormView(isPresented: $showingNewBudgetForm, initialExpense: currentExpense, categories: getValidCategories(), onSave: { newBudget in
                    self.budgets.append(newBudget)
                })
                .background(Color("BackgroundColor")) 
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

    private func loadCategories() {
        categoryManager.getAllCategories { categories, error in
            if let categories = categories {
                self.categories = categories
            } else if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
            }
        }
    }
    
    private func getValidCategories() -> [CategoryViewModel] {
           return categories.filter { $0.budgetId == nil || $0.budgetId?.isEmpty == true }
       }
}






