//
//  TopSalesStatView.swift
//  SalesReceipt
//
//  Created by Quasar on 11.12.2024.
//

import SwiftUI

struct TopSalesStatView: View {
    let topItemSales: [(item: Item, count: Int)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Sales")
                .font(.headline)
                .padding(.horizontal)
            
            if !topItemSales.isEmpty {
                VStack(spacing: 10) {
                    ForEach(topItemSales, id: \.item.id) { item, count in
                        HStack {
                            Text(item.description.value)
                                .font(.subheadline)
                            Spacer()
                            Text("\(count) pcs.")
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .innerStroke(inset: 1)
                    }
                }
                .padding(.horizontal)
            } else {
                Text("No sales data available.")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
    }
}

struct TopSalesStatView_Previews: PreviewProvider {
    static var previews: some View {
        let salesStats = MockStatisticsManager().getItemSalesStats() ?? [:]
        let topItemSales = salesStats.map { (item: $0.key, count: $0.value) }
        return TopSalesStatView(topItemSales: topItemSales)
    }
}

