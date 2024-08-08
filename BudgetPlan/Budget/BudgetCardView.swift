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
            }
            
            HStack {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 10)
                            .opacity(0.3)
                            .foregroundColor(.gray)

                        Rectangle()
                            .frame(width: min(CGFloat(self.budget.leftAmount / self.budget.amount) * geometry.size.width, geometry.size.width), height: 10)
                            .foregroundColor(Color("AccentColor"))
                    }
                }
            }
            .frame(height: 10)

            HStack {
                Text("Left:")
                    .font(.subheadline)
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
}


