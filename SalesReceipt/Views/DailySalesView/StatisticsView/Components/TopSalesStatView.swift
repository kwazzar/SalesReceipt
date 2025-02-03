//
//  TopSalesStatView.swift
//  SalesReceipt
//
//  Created by Quasar on 11.12.2024.
//

import SwiftUI

struct TopSalesStatView: View {
    private let topItemSales: [TopItemStat]

    init(_ topItemSales: [TopItemStat]) {
        self.topItemSales = topItemSales
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Sales")
                .font(.headline)
                .padding(.horizontal)
            
            if !topItemSales.isEmpty {
                VStack(spacing: 10) {
                    ForEach(topItemSales, id: \.item.id) { stat in
                        HStack {
                            Text(stat.item.description.value)
                                .font(.subheadline)
                            Spacer()
                            Text(stat.quantity.formatted)
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

        let topItemStats = [
            TopItemStat(item: mockItems[0], count: 10),
            TopItemStat(item: mockItems[1], count: 7),
            TopItemStat(item: mockItems[2], count: 5)
        ]

        TopSalesStatView(topItemStats)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
