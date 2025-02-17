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
                loadingView
            } else if viewModel.isDataEmpty {
                noDataView
            } else {
                statisticsScrollView
            }
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .top)
        .onChange(of: viewModel.isDataLoaded) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.5)) {
                    viewModel.isAnimating = true
                }
            }
        }
    }
}
// MARK: - Content Views
private extension StatisticsView {    
    var statisticsHeader: some View {
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
    
    var loadingView: some View {
        ProgressView()
            .frame(maxHeight: .infinity)
    }
    
    var noDataView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No Statistics Available")
                .font(.headline)
            Text("There is no sales data to display")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxHeight: .infinity)
    }
    
    var statisticsScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
                    statisticsContent
                    Spacer(minLength: 40)
                }
                .padding(.vertical, 16)
                .id("top")
            }
            .onChange(of: bottomSheetState) {
                viewModel.handleBottomSheetStateChange($0, proxy: proxy) }
            .introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18)) { scroll in
                scroll.bounces = false
            }
            .scrollIndicators(.hidden)
        }
    }

    var statisticsContent: some View {
        VStack(spacing: 20) {
            totalStatsSection
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .opacity
                ))

            dailySalesSection
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))

            topSalesSection
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity)
                ))
        }
        .opacity(viewModel.isAnimating ? 1 : 0)
        .animation(.easeInOut(duration: 0.4).delay(0.1), value: viewModel.totalSalesStats)
        .animation(.easeInOut(duration: 0.4).delay(0.2), value: viewModel.dailySalesStats)
        .animation(.easeInOut(duration: 0.4).delay(0.3), value: viewModel.topItemSales)
    }
}

// MARK: - Statistics Sections
private extension StatisticsView {
    @ViewBuilder
    var totalStatsSection: some View {
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
    }
    
    @ViewBuilder
    var dailySalesSection: some View {
        if !viewModel.dailySalesStats.isEmpty {
            SalesChartView(viewModel.dailySalesStats)
                .transition(.opacity)
        }
    }
    
    @ViewBuilder
    var topSalesSection: some View {
        if !viewModel.topItemSales.isEmpty {
            TopSalesStatView(viewModel.topItemSales)
                .transition(.opacity)
        }
    }
}

//MARK: - Previews
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
