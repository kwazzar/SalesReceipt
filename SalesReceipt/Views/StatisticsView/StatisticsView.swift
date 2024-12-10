//
//  StatisticsView.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import SwiftUI

struct StatisticsView: View {
    @StateObject var viewModel: StatisticsViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let totalStats = viewModel.totalSalesStats {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Overall Statistics")
                                .font(.headline)
                                .padding(.horizontal)

                            HStack {
                                ForEach(StatType.allCases,
                                        id: \.self) { statType in
                                    StatCard(title: statType.title,
                                             value: statType.value(from: totalStats),
                                             color: statType.color)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    SalesChartView(salesStats: viewModel.dailySalesStats)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Top Sales")
                            .font(.headline)
                            .padding(.horizontal)

                        if !viewModel.topItemSales.isEmpty {
                            VStack(spacing: 10) {
                                ForEach(viewModel.topItemSales, id: \.item.id) { item, count in
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
                .padding(.vertical)
            }
            .navigationTitle("Sales Statistics")
            .background(Color(.systemGroupedBackground))
        }
    }
}


struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(viewModel: StatisticsViewModel(statsService: MockStatisticsManager()))
    }
}
