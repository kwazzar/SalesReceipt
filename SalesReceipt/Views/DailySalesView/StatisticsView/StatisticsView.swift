//
//  StatisticsView.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import SwiftUI

#warning("скоріше за все потрібне роздрілення")
struct StatisticsView: View {
    @State var totalSalesStats: (total: Double, itemsSold: Int, averageCheck: Double)?
    @State var dailySalesStats: [SalesStat]
    @State var topItemSales: [(item: Item, count: Int)]
    @Binding var bottomSheetState: BottomSheetState
    let actionClosed: () -> Void
    let isButtonVisible: Bool

    // НОВЫЕ ПАРАМЕТРЫ
    let receipts: [Receipt]
    let searchText: String?
    let statisticsService: StatisticsAPI

    // ОБНОВЛЕННЫЙ ИНИЦИАЛИЗАТОР
    init(
        totalSalesStats: (total: Double, itemsSold: Int, averageCheck: Double)? = nil,
        dailySalesStats: [SalesStat] = [],
        topItemSales: [(item: Item, count: Int)] = [],
        bottomSheetState: Binding<BottomSheetState>,
        actionClosed: @escaping () -> Void,
        isButtonVisible: Bool,
        receipts: [Receipt],
        searchText: String?,
        statisticsService: StatisticsAPI
    ) {
        self._totalSalesStats = State(initialValue: totalSalesStats)
        self._dailySalesStats = State(initialValue: dailySalesStats)
        self._topItemSales = State(initialValue: topItemSales)
        self._bottomSheetState = bottomSheetState
        self.actionClosed = actionClosed
        self.isButtonVisible = isButtonVisible
        self.receipts = receipts
        self.searchText = searchText
        self.statisticsService = statisticsService
    }

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
                        if let totalStats = calculatedTotalStats {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Overall Statistics")
                                    .font(.headline)
                                    .padding(.horizontal)
                                HStack {
                                    ForEach(StatType.allCases, id: \.self) { statType in
                                        StatCard(
                                            title: statType.title,
                                            value: statType.value(from: totalStats),
                                            color: statType.color
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        SalesChartView(calculatedDailySales)
                        TopSalesStatView(calculatedTopSales)
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
        .onAppear(perform: calculateStatistics)
        .onChange(of: receipts) { _ in calculateStatistics() }
        .onChange(of: searchText ?? "") { _ in calculateStatistics() }
    }

    private var calculatedTotalStats: (total: Double, itemsSold: Int, averageCheck: Double)? {
        statisticsService.fetchTotalStats(receipts: filteredReceipts)
    }

    private var calculatedDailySales: [SalesStat] {
        statisticsService.fetchDailySales(receipts: filteredReceipts) ?? []
    }
    
    private var calculatedTopSales: [(item: Item, count: Int)] {
        statisticsService.fetchTopItemSales(receipts: receipts, searchText: searchText, limit: 3)
    }

    private var filteredReceipts: [Receipt] {
        if let searchText = searchText, !searchText.isEmpty {
            return receipts.filter { receipt in
                receipt.items.contains {
                    $0.description.value.lowercased().contains(searchText.lowercased())
                }
            }
        }
        return receipts
    }

    private func calculateStatistics() {
        totalSalesStats = calculatedTotalStats
        dailySalesStats = calculatedDailySales
        topItemSales = calculatedTopSales
    }
}

//struct StatisticsView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatisticsView(viewModel: StatisticsViewModel(statsService: MockStatisticsManager()), actionClosed: {}, isButtonVisible: true)
//    }
//}
