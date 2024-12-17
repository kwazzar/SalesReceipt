//
//  StatisticsView.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import SwiftUI

struct StatisticsView: View {
    @State var totalSalesStats: (total: Double, itemsSold: Int, averageCheck: Double)?
    @State var dailySalesStats: [SalesStat]
    @State var topItemSales: [(item: Item, count: Int)]
    @Binding var bottomSheetState: BottomSheetState 
    let actionClosed: () -> Void
    let isButtonVisible: Bool
    
    
    var body: some View {
        VStack(spacing: 0) {
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
            .padding(.bottom, 3)
            .background(Color(.systemBackground))
            .zIndex(100)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        if let totalStats = totalSalesStats {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Overall Statistics")
                                    .font(.headline)
                                    .padding(.horizontal)
                                HStack {
                                    ForEach(StatType.allCases, id: \.self) { statType in
                                        StatCard(title: statType.title,
                                                 value: statType.value(from: totalStats),
                                                 color: statType.color)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        SalesChartView(dailySalesStats)
                        TopSalesStatView(topItemSales)
                    }
                    .padding(.vertical, 16)
                    .id("top")
                }
                .onChange(of: bottomSheetState) { newState in
                    if newState == .closed {
                        withAnimation {
                            proxy.scrollTo("top", anchor: .top)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea(edges: .top)
    }
}

//struct StatisticsView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatisticsView(viewModel: StatisticsViewModel(statsService: MockStatisticsManager()), actionClosed: {}, isButtonVisible: true)
//    }
//}
