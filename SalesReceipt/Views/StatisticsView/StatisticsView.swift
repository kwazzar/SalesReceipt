//
//  StatisticsView.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import SwiftUI
import SwiftUIIntrospect


struct StatisticsView: View {
    @StateObject var viewModel: StatisticsViewModel
    let actionClosed: () -> Void
    let isButtonVisible: Bool
    
    var body: some View {
        ScrollView {
            ZStack {
                Text("Statistics")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .padding(.top, 15)
                
                HStack {
                    Spacer()
                    if isButtonVisible {
                        StatisticsClosedButton(actionClosed)
                    }
                }
            }
            
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
        .scrollIndicators(.hidden)
        .introspect(.scrollView, on: .iOS(.v15), .iOS(.v16), .iOS(.v17), .iOS(.v18), customize: { scroll in
            scroll.bounces = false
        })
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(viewModel: StatisticsViewModel(statsService: MockStatisticsManager()), actionClosed: {}, isButtonVisible: true)
    }
}
