import SwiftUI

struct NewBudgetFormView: View {
    @Binding var isPresented: Bool
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
    
    init(isPresented: Binding<Bool>, initialExpense: Bool, categories: [CategoryViewModel], onSave: @escaping (BudgetsViewModel) -> Void) {
        self._isPresented = isPresented
        self._expense = State(initialValue: initialExpense)
        self.categories = categories
        self.onSave = onSave
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
                            .background(selectedCategoryIds.contains(category.id) ? Color("SelectedCategoryBackgroundColor") : Color.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                toggleCategorySelection(category: category)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("New Budget", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
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
        let budgetId = UUID().uuidString
        
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
        
        for categoryId in selectedCategoryIds {
            if let category = categories.first(where: { $0.id == categoryId }) {
                dispatchGroup.enter()
                var updatedCategory = category
                updatedCategory.budgetId = budgetId
                
                categoryManager.updateCategory(category: updatedCategory) { error in
                    if let error = error {
                        saveError = error
                        alertMessage = "Error updating category \(category.name): \(error.localizedDescription)"
                        showAlert = true
                        isPresented = false
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = saveError {
                print("Error updating categories: \(error.localizedDescription)")
                alertMessage = "There was an error updating the categories. Please try again later."
                showAlert = true
                isPresented = false
            } else {
                budgetManager.addNewBudget(budget: newBudget) { error in
                    if let error = error {
                        print("Error saving new budget: \(error.localizedDescription)")
                        alertMessage = "There was an error saving the new budget. Please try again later."
                        showAlert = true
                        isPresented = false
                    } else {
                        onSave(newBudget)
                        isPresented = false
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
