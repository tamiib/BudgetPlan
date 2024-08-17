//
//  NewBudgetFormView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 13.08.2024..

import SwiftUI

struct BudgetFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var amount: Double = 0.0
    @State private var leftAmount: Double = 0.0
    @State private var selectedCategoryIds: Set<String> = []
    @State private var expense: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""
    private let categoryManager = CategoryManager()
    private let budgetManager = BudgetManager()
    
    var onSave: (BudgetsViewModel) -> Void
    var categories: [CategoryViewModel]
    
    @State private var budget: BudgetsViewModel?

    init(budget: BudgetsViewModel?, categories: [CategoryViewModel], onSave: @escaping (BudgetsViewModel) -> Void) {
        self._expense = State(initialValue: budget?.expense ?? true)
        self._budget = State(initialValue: budget)
        self.categories = categories
        self.onSave = onSave
        
        if let budget = budget {
            _name = State(initialValue: budget.name)
            _icon = State(initialValue: budget.icon)
            _amount = State(initialValue: budget.amount)
            _leftAmount = State(initialValue: budget.leftAmount)
            _selectedCategoryIds = State(initialValue: Set(budget.categoryIds))
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                Form {
                    Section(header: Text("Budget Details")) {
                        TextField("Name", text: $name)
                        
                        TextField("Icon (Emoji)", text: $icon)
                            .keyboardType(.default)
                        
                        Toggle("Expense", isOn: $expense)
                            .tint(Color("AccentColor"))
                    }
                    
                    Section(header: Text("Amounts")) {
                        
                        VStack(alignment: .leading) {
                            Text("Amount")
                                .foregroundColor(.gray)
                                .padding(.bottom, 0)
                            TextField("Enter amount", value: $amount, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Left Amount")
                                .foregroundColor(.gray)
                                .padding(.bottom, 0)
                            TextField("Left Amount", value: $leftAmount, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    Section(header: Text("Categories")) {
                        ForEach(categories, id: \.id) { category in
                            HStack {
                                Text(category.icon)
                                Text(category.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedCategoryIds.contains(category.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color("DarkBrownColor"))
                                }
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedCategoryIds.contains(category.id) ? Color("AccentColor") : Color.clear, lineWidth: 2))
                            .cornerRadius(8)
                            .onTapGesture {
                                toggleCategorySelection(category: category)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(budget == nil ? "New Budget" : "Edit Budget", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                saveBudget()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func saveBudget() {
        let budgetId = budget?.id ?? UUID().uuidString
        
        let newBudget = BudgetsViewModel(
            id: budgetId,
            name: name,
            categoryIds: Array(selectedCategoryIds),
            amount: amount,
            leftAmount: leftAmount,
            expense: expense,
            currency: "",
            icon: icon
        )
        
        let dispatchGroup = DispatchGroup()
        var saveError: Error?
        
        for category in categories {
            dispatchGroup.enter()
            
            if selectedCategoryIds.contains(category.id) {
                var updatedCategory = category
                updatedCategory.budgetId = budgetId
                categoryManager.updateCategory(category: updatedCategory) { error in
                    if let error = error {
                        saveError = error
                    }
                    dispatchGroup.leave()
                }
            }
            else if category.budgetId == budgetId {
                var updatedCategory = category
                updatedCategory.budgetId = ""
                categoryManager.updateCategory(category: updatedCategory) { error in
                    if let error = error {
                        saveError = error
                    }
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = saveError {
                print("Error updating categories: \(error.localizedDescription)")
                alertMessage = "There was an error updating the categories. Please try again later."
                showAlert = true
                presentationMode.wrappedValue.dismiss()
            } else {
                if budget != nil {
                    budgetManager.updateBudget(budget: newBudget) { error in
                        if let error = error {
                            print("Error updating budget: \(error.localizedDescription)")
                            alertMessage = "There was an error updating the budget. Please try again later."
                            showAlert = true
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            onSave(newBudget)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                } else {
                    budgetManager.addNewBudget(budget: newBudget) { error in
                        if let error = error {
                            print("Error saving new budget: \(error.localizedDescription)")
                            alertMessage = "There was an error saving the new budget. Please try again later."
                            showAlert = true
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            onSave(newBudget)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    private func toggleCategorySelection(category: CategoryViewModel) {
        if selectedCategoryIds.contains(category.id) {
            selectedCategoryIds.remove(category.id)
        } else {
            selectedCategoryIds.insert(category.id)
        }
    }
}

