//
//  ReceiptView.swift
//  SalesReceipt
//
//  Created by Quasar on 08.11.2024.
//

import SwiftUI

struct ReceiptView: View {
    let items: [Item]
    let total: Double

    var body: some View {
        VStack(spacing: 10) {
            Text("Receipt")
                .font(.headline)
                .padding(.top, 10)
            Divider()

            List(items, id: \.id) { item in
                HStack {
                    Text(item.description)
                        .font(.body)
                    Spacer()
                    Text(String(format: "%.2f $", item.price.value))
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 5)
            }
            .listStyle(PlainListStyle())

            Divider()
            HStack {
                Text("Total:")
                    .font(.headline)
                Spacer()
                Text(String(format: "%.2f $", total))
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
        .shadow(radius: 5)
        .innerStroke(cornerRadius: 20, lineWidth: 2, color: .black, inset: 15)
    }
}

//struct ReceiptView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Зразкові дані для попереднього перегляду
//        let sampleItems = [
//            Item(id: 1, description: "Product A", price: Price(value: 9.99), image: "cart"),
//            Item(id: 2, description: "Product B", price: Price(value: 5.49), image: "bag"),
//            Item(id: 3, description: "Product C", price: Price(value: 12.75), image: "gift")
//        ]
//
//        // Підрахунок загальної суми
//        let total = sampleItems.reduce(0) { $0 + $1.price.value }
//
//        return ReceiptView(items: sampleItems, total: total)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
