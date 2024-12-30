//
//  StatisticsView.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import SwiftUI

#warning("коли віднімаеш вверх від 0 стану view стає прозорим")
struct StatisticsView: View {
    @ObservedObject private var viewModel: StatisticsViewModel
    @Binding var bottomSheetState: BottomSheetState
    let actionClosed: () -> Void
    let isButtonVisible: Bool

    init(
        bottomSheetState: Binding<BottomSheetState>,
        actionClosed: @escaping () -> Void,
        isButtonVisible: Bool,
        receipts: [Receipt],
        searchText: String?,
        statisticsService: StatisticsAPI
    ) {
        self._bottomSheetState = bottomSheetState
        self.actionClosed = actionClosed
        self.isButtonVisible = isButtonVisible
        self._viewModel = ObservedObject(wrappedValue: StatisticsViewModel(
            statisticsService: statisticsService, receipts: receipts,
            searchText: searchText
        ))
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
                        if let totalStats = viewModel.totalSalesStats {
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
                        SalesChartView(viewModel.dailySalesStats)
                        TopSalesStatView(viewModel.topItemSales)
                        Spacer(minLength: 40)
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
            .introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18), customize: { scroll in
                scroll.bounces = false
            })
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea(edges: .top)
        .onAppear(perform: viewModel.calculateStatistics)
        .onChange(of: viewModel.receipts) { _ in viewModel.calculateStatistics() }
        .onChange(of: viewModel.searchText ?? "") { _ in viewModel.calculateStatistics() }
    }
}
