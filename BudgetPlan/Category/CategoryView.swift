//
//  CategoryView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 09.08.2024..
//
import SwiftUI

struct CategoryView: View {
    @State private var categories: [CategoryViewModel] = []
    @State private var budgets: [BudgetsViewModel] = []
    @State private var filteredBudgets: [BudgetsViewModel] = []
    @State private var selectedCategory: CategoryViewModel?
    @State private var selectedBudgetId: String = "All"
    @State private var isAddCategoryPresented: Bool = false

    private let categoryManager = CategoryManager()
    private let budgetManager = BudgetManager()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Categories")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    isAddCategoryPresented = true
                }) {
                    Image(systemName: "plus")
                        .imageScale(.medium)
                        .padding(5)
                        .background(Color("AccentColor"))
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal)

           
            Picker("Select Budget", selection: $selectedBudgetId) {
                Text("All Categories").tag("All")
                Text("No Budget").tag("NoBudget")
                ForEach(filteredBudgets, id: \.id) { budget in
                    Text(budget.name)
                        .foregroundColor(.black) 
                        .tag(budget.id)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal, 16)
            .background(Color("LightBrown"))
            .cornerRadius(10)
            .padding(.bottom, 8)
            .padding(.top, 10)

            ScrollView {
                FlowLayout(categories: filteredCategories, selectedCategory: $selectedCategory, backgroundColorName: "White")
                    .padding(.horizontal, 16)
            }
            Spacer()
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchBudgetsAndCategories()
        }
        .sheet(isPresented: $isAddCategoryPresented) {
            AddCategoryView(budgets: budgets, onSave: { newCategory in
                categories.append(newCategory)
                isAddCategoryPresented = false
            })
        }
    }

    private var filteredCategories: [CategoryViewModel] {
        switch selectedBudgetId {
        case "All":
            return categories
        case "NoBudget":
            return categories.filter { $0.budgetId == nil || $0.budgetId == "" }
        default:
            return categories.filter { $0.budgetId == selectedBudgetId }
        }
    }

    private func fetchBudgetsAndCategories() {
        categoryManager.getAllCategories { categories, error in
            if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
            } else {
                self.categories = categories ?? []
                loadBudgets()
            }
        }
    }

    private func loadBudgets() {
        budgetManager.getAllBudgets { budgets, error in
            if let error = error {
                print("Error fetching budgets: \(error.localizedDescription)")
            } else {
                guard let budgets = budgets else { return }
                self.budgets = budgets
            
                self.filteredBudgets = budgets.filter { budget in
                    categories.contains { $0.budgetId == budget.id }
                }
            }
        }
    }
}


