//
//  StatisticsView.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import SwiftUI

#warning("добавить фильтри статиски")
struct StatisticsView: View {
    @StateObject var viewModel: StatisticsViewModel
    
    var body: some View {
        ScrollView {
            Text("Statistics")
                .font(.system(size: 30, weight: .bold, design: .default))
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
                TopSalesStatView(topItemSales: viewModel.topItemSales)
            }
            .padding(.vertical, 1)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(viewModel: StatisticsViewModel(statsService: MockStatisticsManager()))
    }
}
