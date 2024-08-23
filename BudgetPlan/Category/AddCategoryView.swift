//
//  AddCategoryView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 18.08.2024..
//
import SwiftUI

struct AddCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var categoryName: String = ""
    @State private var categoryIcon: String = ""
    @State private var selectedBudget: BudgetsViewModel?
    @State private var showAlert = false
    @State private var alertMessage = ""

    var budgets: [BudgetsViewModel]
    var onSave: (CategoryViewModel) -> Void

    private let categoryManager = CategoryManager()
    private let budgetManager = BudgetManager()

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    
                        Image(systemName: "arrow.backward")
                        .foregroundColor(Color("AccentColor"))
                        Text("Back")
                            .font(.headline)
                    .foregroundColor(Color("AccentColor"))
                }

                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal)
            
            Text("Add Category")
            
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 10)

            Form {
                Section(header: Text("Category Details")) {
                    TextField("Category Name", text: $categoryName)
                    TextField("Category Icon", text: $categoryIcon)
                }

                Section(header: Text("Assign to Budget")) {
                    Picker("Select Budget", selection: $selectedBudget) {
                        Text("No Budget").tag(nil as BudgetsViewModel?)
                        ForEach(budgets, id: \.id) { budget in
                            Text(budget.name).tag(budget as BudgetsViewModel?)
                        }
                    }
                }
            }

            Button(action: saveCategory) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentColor"))
                    .cornerRadius(8)
            }
            .disabled(categoryName.isEmpty || categoryIcon.isEmpty)
            .opacity(categoryName.isEmpty || categoryIcon.isEmpty ? 0.5 : 1.0)
            .padding(.horizontal, 20)
            .padding(.top, 10)

            Spacer()
        }
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func saveCategory() {
        let newCategory = CategoryViewModel(
            name: categoryName,
            icon: categoryIcon,
            budgetId: nil
        )
        
        categoryManager.addCategory(category: newCategory) { error in
            if let error = error {
                alertMessage = "Error saving category: \(error.localizedDescription)"
                showAlert = true
                return
            }

            guard let categoryId = newCategory.id as String?, var selectedBudget = selectedBudget else {
                onSave(newCategory)
                return
            }

            selectedBudget.categoryIds.append(categoryId)
            budgetManager.updateBudget(budget: selectedBudget) { error in
                if let error = error {
                    alertMessage = "Error updating budget: \(error.localizedDescription)"
                    showAlert = true
                    return
                }

                var updatedCategory = newCategory
                updatedCategory.budgetId = selectedBudget.id
                categoryManager.addCategory(category: updatedCategory) { error in
                    if let error = error {
                        alertMessage = "Error updating category with budget: \(error.localizedDescription)"
                        showAlert = true
                    } else {
                        onSave(updatedCategory)
                    }
                }
            }
        }
    }
}
