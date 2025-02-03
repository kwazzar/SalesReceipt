//
//  StatisticsView.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import SwiftUI

struct StatisticsView: View {
    @ObservedObject private var viewModel: StatisticsViewModel
    @Binding private var bottomSheetState: BottomSheetState
    private let actionClosed: () -> Void
    private let isButtonVisible: Bool

    init(viewModel: StatisticsViewModel,
         bottomSheetState: Binding<BottomSheetState>,
         actionClosed: @escaping () -> Void,
         isButtonVisible: Bool) {
        self.viewModel = viewModel
        self._bottomSheetState = bottomSheetState
        self.actionClosed = actionClosed
        self.isButtonVisible = isButtonVisible
    }
    
    var body: some View {
        VStack(spacing: 0) {
            statisticsHeader
                .background(Color(.systemBackground))
                .zIndex(100)
            
            if !viewModel.isDataLoaded {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 20) {
                            statisticsContent
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
                .introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18)) { scroll in
                    scroll.bounces = false
                }
                .scrollIndicators(.hidden)
            }
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .top)
    }
}

extension StatisticsView {
    //MARK: - Header
    private var statisticsHeader: some View {
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
    }

    //MARK: - Content
    private var statisticsContent: some View {
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
                .transition(.opacity)
            }

            if !viewModel.dailySalesStats.isEmpty {
                SalesChartView(viewModel.dailySalesStats)
                    .transition(.opacity)
            }

            if !viewModel.topItemSales.isEmpty {
                TopSalesStatView(viewModel.topItemSales)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.totalSalesStats)
        .animation(.easeInOut, value: viewModel.dailySalesStats)
        .animation(.easeInOut, value: viewModel.topItemSales)
    }
}

struct Statistics_Previews: PreviewProvider {
    static var previews: some View {

        let viewModel = StatisticsViewModel(
            statisticsService: StatisticsManager(),
            receipts: testReceipts,
            searchText: nil,
            topSalesLimit: 5
        )

        StatisticsView(
            viewModel: viewModel,
            bottomSheetState: .constant(.expanded),
            actionClosed: { print("closed") },
            isButtonVisible: true
        )
    }
}
