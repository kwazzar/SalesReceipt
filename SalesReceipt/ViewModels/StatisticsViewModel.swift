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
    @Published private(set) var dailySalesStats: [DailySales] = []
    @Published private(set) var topItemSales: [TopItemStat] = []
    @Published private(set) var isDataLoaded = false

    // MARK: - Input Properties
    @Published var receipts: [Receipt] {
        didSet {
            if receipts != oldValue {
                calculateStatistics()
            }
        }
    }

    @Published var searchText: String? {
        didSet {
            if searchText != oldValue {
                calculateStatistics()
            }
        }
    }

    // MARK: - Dependencies
    private let statisticsService: StatisticsAPI
    private let topSalesLimit: Int
    private var calculationTask: Task<Void, Never>?

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
            await preloadStatistics()
        }
    }

    // MARK: - Public Methods
    private var isCalculating = false
    private var previousFilteredReceipts: [Receipt] = []
    
    func calculateStatistics() {
        guard !isCalculating else { return }
        
        let newFilteredReceipts = filteredReceipts
        guard newFilteredReceipts != previousFilteredReceipts else { return }
        previousFilteredReceipts = newFilteredReceipts
        
        isCalculating = true
        calculationTask?.cancel()
        calculationTask = Task { @MainActor in
            defer { isCalculating = false }
            guard !Task.isCancelled else { return }

            let currentTotalStats = self.totalSalesStats
            let currentDailySales = self.dailySalesStats
            let currentTopSales = self.topItemSales
            
            async let totalStats = statisticsService.fetchTotalStats(receipts: newFilteredReceipts)
            async let dailySales = statisticsService.fetchDailySales(receipts: newFilteredReceipts)
            async let topSales = statisticsService.fetchTopItemSales(
                receipts: receipts,
                searchText: searchText,
                limit: topSalesLimit
            )
            
            let (newStats, newSales, newTop) = await (totalStats, dailySales, topSales)
            
            guard !Task.isCancelled else { return }
            
            if newStats != nil || currentTotalStats == nil {
                self.totalSalesStats = newStats.map { TotalStats(total: $0.total, itemsSold: $0.itemsSold, averageCheck: $0.averageCheck.amount) }
            }
            if let newSales = newSales {
                self.dailySalesStats = newSales
            }
            if !newTop.isEmpty || currentTopSales.isEmpty {
                self.topItemSales = newTop.map { TopItemStat(item: $0.item, count: Quantity($0.count).value) }
            }
        }
    }

    private func preloadStatistics() async {
        guard !isCalculating else { return }
        
        isCalculating = true
        defer { isCalculating = false }
        
        async let totalStats = statisticsService.fetchTotalStats(receipts: filteredReceipts)
        async let dailySales = statisticsService.fetchDailySales(receipts: filteredReceipts)
        async let topSales = statisticsService.fetchTopItemSales(
            receipts: receipts,
            searchText: searchText,
            limit: topSalesLimit
        )
        
        let (stats, sales, top) = await (totalStats, dailySales, topSales)
        
        await MainActor.run {
            self.totalSalesStats = stats.map { TotalStats(total: $0.total, itemsSold: $0.itemsSold, averageCheck: $0.averageCheck.amount) }
            self.dailySalesStats = sales ?? []
            self.topItemSales = top.map { TopItemStat(item: $0.item, count: Quantity($0.count).value) }
            self.isDataLoaded = true
        }
    }
}

// MARK: - Private Methods
extension StatisticsViewModel {
    private var calculatedTotalStats: TotalStats? {
        statisticsService.fetchTotalStats(receipts: filteredReceipts)
    }

    private var calculatedDailySales: [DailySales] {
        statisticsService.fetchDailySales(receipts: filteredReceipts) ?? []
    }

    private var calculatedTopSales: [TopItemStat] {
        statisticsService.fetchTopItemSales(
            receipts: receipts,
            searchText: searchText,
            limit: topSalesLimit
        )
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
