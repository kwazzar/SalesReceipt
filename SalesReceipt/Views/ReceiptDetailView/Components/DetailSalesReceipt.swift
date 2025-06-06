//
//  DetailSalesReceipt.swift
//  SalesReceipt
//
//  Created by Quasar on 30.11.2024.
//

import SwiftUI

struct DetailSalesReceipt: View {
    let receipt: Receipt
    
    init(_ receipt: Receipt) {
        self.receipt = receipt
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Sales Receipt")
                .font(.title)
                .bold()
            Text("\(receipt.id)")
                .padding(.bottom, 10)

            Text("Customer: \(receipt.customerName.value)")
                .font(.headline)
            Text("Date: \(formattedDate(receipt.date))")
                .font(.subheadline)
            Divider()

            HStack {
                Text("Qty").bold()
                    .frame(width: 40, alignment: .leading)
                Text("Item").bold()
                Spacer()
                Text("Price").bold()
            }
            .padding(.vertical, 5)
            Divider()
            ForEach(receipt.items, id: \.self) { item in
                HStack {
                    Text("\(item.quantity)x")
                        .frame(width: 40, alignment: .leading)
                        .foregroundColor(.gray)
                    Text(item.description.value)
                    Spacer()
                    Text(String(format: "%.2f $", item.price.value))
                }
                .padding(.vertical, 2)
            }
            Divider()
            // Итоговая сумма
            HStack {
                Text("Total").bold()
                Spacer()
                Text(String(format: "%.2f $", receipt.total))
                    .bold()
            }
            .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .innerStroke(inset: 2)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
