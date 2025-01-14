//
//  StatisticsViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 19.12.2024.
//

import Foundation

final class StatisticsViewModel: ObservableObject {
    @Published var totalSalesStats: (total: Double, itemsSold: Int, averageCheck: Double)?
    @Published var dailySalesStats: [SalesStat] = []
    @Published var topItemSales: [(item: Item, count: Int)] = []

    private let statisticsService: StatisticsAPI
    @Published var receipts: [Receipt] {
        didSet { calculateStatistics() }
    }
    @Published var searchText: String? {
        didSet { calculateStatistics() }
    }

    init(
        statisticsService: StatisticsAPI,
        receipts: [Receipt],
        searchText: String?
    ) {
        self.statisticsService = statisticsService
        self.receipts = receipts
        self.searchText = searchText
        calculateStatistics()
    }

    func calculateStatistics() {
        totalSalesStats = calculatedTotalStats
        dailySalesStats = calculatedDailySales
        topItemSales = calculatedTopSales
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
                receipt.customerName.value.lowercased().contains(searchText.lowercased()) ||
                receipt.items.contains {
                    $0.description.value.lowercased().contains(searchText.lowercased())
                }
            }
        }
        return receipts
    }
}
