//
//  StatisticsViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import Foundation

final class StatisticsViewModel: ObservableObject {
    @Published var totalSalesStats: (total: Double, itemsSold: Int, averageCheck: Double)?
    @Published var dailySalesStats: [SalesStat] = []
    @Published var topItemSales: [(item: Item, count: Int)] = []

    private let statsService: StatisticsAPI

    init(statsService: StatisticsAPI) {
        self.statsService = statsService
        fetchStatistics()
    }


    private func fetchStatistics() {
        totalSalesStats = statsService.getTotalSalesStats()

        if let dailyStats = statsService.getDailySalesStats() {
            dailySalesStats = dailyStats
        }

        if let itemStats = statsService.getItemSalesStats() {
            topItemSales = Array(itemStats.sorted { $0.value > $1.value }).prefix(5).map { ($0.key, $0.value) }
        }
    }
}
