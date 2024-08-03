// TransactionCardView.swift
// BudgetPlan
//
// Kreirao Tamara Barišić 02.07.2024.
//

import SwiftUI

struct TransactionCardView: View {
    let transaction: TransactionViewModel
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }
    
    private var amountColor: Color {
        Color("AccentColor")
    }
    
    var body: some View {
        HStack(spacing: 12) {
          
            VStack(alignment: .leading, spacing: 4) {
                Text(dayFormatter.string(from: transaction.created))
                    .font(.headline)
                    .foregroundColor(.black)
                Text(monthFormatter.string(from: transaction.created))
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .frame(width: UIScreen.main.bounds.width / 6)
            
           
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description)
                    .font(.body)
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                Text(transaction.bankAccountName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(width: UIScreen.main.bounds.width * 3 / 6)
            
           
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.2f", transaction.amount))
                    .font(.body)
                    .foregroundColor(amountColor)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5) 
    }
}

