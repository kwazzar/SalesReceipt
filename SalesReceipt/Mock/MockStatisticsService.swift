//
//  MockStatisticsService.swift
//  SalesReceipt
//
//  Created by Quasar on 15.02.2025.
//

import Foundation

final class MockStatisticsService: StatisticsAPI {
    var totalStatsToReturn: TotalStats?
    var dailySalesToReturn: [DailySalesStat]?
    var topItemSalesToReturn: [TopItemStat]?
    var isFetchCalled = false

    func fetchTotalStats(receipts: [Receipt]) -> TotalStats? {
        isFetchCalled = true
        print("Fetching total stats with receipts: \(receipts)")
        return totalStatsToReturn
    }

    func fetchDailySales(receipts: [Receipt]) -> [DailySalesStat]? {
        isFetchCalled = true // Ensure this is set
        return dailySalesToReturn ?? []
    }

    func fetchTopItemSales(receipts: [Receipt], searchText: String?, limit: Int) -> [TopItemStat] {
        isFetchCalled = true // Ensure this is set
        return topItemSalesToReturn ?? []
    }
}
