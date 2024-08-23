//
//  BudgetCardView.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 08.08.2024..
//

import SwiftUI

struct BudgetCardView: View {
    let budget: BudgetsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(budget.icon)
                Text(budget.name)
                    .font(.headline)
                Spacer()
                Text(String(format: "%.2f", budget.amount) + budget.currency)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            
            HStack {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 10)
                            .opacity(0.3)
                            .foregroundColor(.gray)
                            .cornerRadius(10)

                        Rectangle()
                            .frame(width: self.widthForBudget(geometryWidth: geometry.size.width), height: 10)
                            .foregroundColor(Color("AccentColor"))
                            .cornerRadius(10)
                    }
                }
            }
            .frame(height: 10)

            HStack {
                if(budget.expense){
                    Text("Left:")
                        .font(.subheadline)
                }
                else {
                    Text("Collected:")
                        .font(.subheadline)
                }
            
                Spacer()
                Text(String(format: "%.2f", budget.leftAmount) + budget.currency)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    private func widthForBudget(geometryWidth: CGFloat) -> CGFloat {
        guard budget.amount > 0 else {
            return 0
        }
        
        let ratio = budget.leftAmount / budget.amount
        return max(min(CGFloat(ratio) * geometryWidth, geometryWidth), 0) 
    }
}


