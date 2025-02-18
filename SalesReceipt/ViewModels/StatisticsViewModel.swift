//
//  StatisticsViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 19.12.2024.
//

import SwiftUI

final class StatisticsViewModel: ObservableObject {
    // MARK: - Published Properties (Output)
    @Published private(set) var totalSalesStats: TotalStats?
    @Published private(set) var dailySalesStats: [DailySalesStat] = []
    @Published private(set) var topItemSales: [TopItemStat] = []
    @Published private(set) var isDataLoaded: Bool = false
    @Published var isAnimating: Bool = false

    // MARK: - Input Properties
    @Published var receipts: [Receipt] {
        didSet {
            handleInputChange()
        }
    }

    @Published var searchText: String? {
        didSet {
            handleInputChange()
        }
    }

    // MARK: - Dependencies
    private let statisticsService: StatisticsAPI
    private let topSalesLimit: Int

    // MARK: - Private State
    private var calculationTask: Task<Void, Never>?
    private var isCalculating = false
    private var previousFilteredReceipts: [Receipt] = []

    // MARK: - Initialization
    init(
        statisticsService: StatisticsAPI,
        receipts: [Receipt],
        searchText: String? = nil,
        topSalesLimit: Int = 5
    ) {
        self.statisticsService = statisticsService
        self.receipts = receipts
        self.searchText = searchText
        self.topSalesLimit = topSalesLimit

        Task { @MainActor in
            loadStatistics()
        }
    }

    deinit {
        calculationTask?.cancel()
    }

    // MARK: - Public Methods

    /// Refreshes all statistics data
    func refreshStatistics() {
        loadStatistics()
    }

    // MARK: - Private Methods
    private func handleInputChange() {
        guard !isCalculating else { return }

        let newFilteredReceipts = filteredReceipts
        guard newFilteredReceipts != previousFilteredReceipts else { return }

        previousFilteredReceipts = newFilteredReceipts
        loadStatistics()
    }

    private func loadStatistics() {
        guard !isCalculating else { return }

        isCalculating = true
        calculationTask?.cancel()

        calculationTask = Task { @MainActor in
            defer { isCalculating = false }
            guard !Task.isCancelled else { return }

            let filteredReceipts = self.filteredReceipts

            try? await Task.sleep(nanoseconds: 100_000_000)

            async let totalStatsTask = statisticsService.fetchTotalStats(receipts: filteredReceipts)
            async let dailySalesTask = statisticsService.fetchDailySales(receipts: filteredReceipts)
            async let topSalesTask = statisticsService.fetchTopItemSales(
                receipts: receipts,
                searchText: searchText,
                limit: topSalesLimit
            )

            let (newTotalStats, newDailySales, newTopSales) = await (totalStatsTask, dailySalesTask, topSalesTask)

            guard !Task.isCancelled else { return }

            print("Fetched total stats: \(String(describing: newTotalStats))")
            print("Fetched daily sales: \(String(describing: newDailySales))")
            print("Fetched top sales: \(newTopSales)")

            // Update total stats if we have new data or don't have any current data
            if let newStats = newTotalStats {
                self.totalSalesStats = TotalStats(
                    total: newStats.total,
                    itemsSold: newStats.itemsSold,
                    averageCheck: newStats.averageCheck.amount
                )
            }

            // Always update daily sales when we get new data, even if it's nil
            if let newSales = newDailySales {
                self.dailySalesStats = newSales
            }

            // Update top sales if we have new data or don't have any current data
            if !newTopSales.isEmpty || self.topItemSales.isEmpty {
                self.topItemSales = newTopSales.map {
                    TopItemStat(item: $0.item, count: Quantity($0.count).value)
                }
            }

            if !self.isDataLoaded {
                self.isDataLoaded = true
            }
        }
    }

    private var filteredReceipts: [Receipt] {
        guard let searchText = searchText, !searchText.isEmpty else {
            return receipts
        }

        return receipts.filter { receipt in
            receipt.customerName.value.lowercased().contains(searchText.lowercased()) ||
            receipt.items.contains {
                $0.description.value.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

// MARK: - Helper Methods
extension StatisticsViewModel {
    var isDataEmpty: Bool {
        totalSalesStats == nil &&
        dailySalesStats.isEmpty &&
        topItemSales.isEmpty
    }

    func handleBottomSheetStateChange(_ newState: BottomSheetState, proxy: ScrollViewProxy) {
        if newState == .closed {
            withAnimation {
                proxy.scrollTo("top", anchor: .top)
            }
        }
    }
}
