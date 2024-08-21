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
    @State private var categories: [CategoryViewModel] = []
    @State private var selectedTab: Bool = true
    @State private var budgetManager = BudgetManager()
    @State private var categoryManager = CategoryManager()
    @State private var currentExpense: Bool = true
    @State private var selectedBudget: BudgetsViewModel? = nil
    @State private var isNewBudget: Bool = false

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
                        currentExpense = newValue
                    }
                    
                    ScrollView {
                        VStack {
                            ForEach(filteredBudgets) { budget in
                                BudgetCardView(budget: budget)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .onTapGesture {
                                        print("Selected budget: \(budget.name)")
                                        selectedBudget = budget
                                        isNewBudget = false
                                    }
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
                            selectedBudget = BudgetsViewModel(id: UUID().uuidString, name: "", categoryIds: [], amount: 0, leftAmount: 0, expense: currentExpense, currency: "", icon: "")
                            isNewBudget = true
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
            .sheet(item: $selectedBudget, onDismiss: {
                isNewBudget = false
            }) { budget in
                BudgetFormView(
                    budget: budget,
                    isNewBudget: isNewBudget,
                    onSave: { savedBudget in
                        if let index = budgets.firstIndex(where: { $0.id == savedBudget.id }) {
                            budgets[index] = savedBudget
                        } else {
                            budgets.append(savedBudget)
                        }
                        loadCategories()
                    }
                )
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
    
    private func getValidCategories(forExistingBudget: Bool) -> [CategoryViewModel] {
        if forExistingBudget {
            print("Fetching valid categories for existing budget with ID: \(selectedBudget?.id ?? "nil")")
            let assignedCategories = categories.filter { selectedBudget?.categoryIds.contains($0.id) ?? false }
            let unassignedCategories = categories.filter { $0.budgetId == nil || $0.budgetId?.isEmpty == true }
            print("Assigned categories: \(assignedCategories.map { $0.name })")
            print("Unassigned categories: \(unassignedCategories.map { $0.name })")
            return assignedCategories + unassignedCategories
        } else {
            print("Fetching valid categories for new budget")
            let unassignedCategories = categories.filter { $0.budgetId == nil || $0.budgetId?.isEmpty == true }
            print("Unassigned categories: \(unassignedCategories.map { $0.name })")
            return unassignedCategories
        }
    }
}

