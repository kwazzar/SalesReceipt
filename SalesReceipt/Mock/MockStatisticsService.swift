//
//  MockStatisticsService.swift
//  SalesReceipt
//
//  Created by Quasar on 15.02.2025.
//

import Foundation

final class MockStatisticsService: StatisticsAPI {
    var totalStatsToReturn: TotalStats?
    var dailySalesToReturn: [DailySales]?
    var topItemSalesToReturn: [TopItemStat]?
    var isFetchCalled = false
    
    func fetchTotalStats(receipts: [Receipt]) -> TotalStats? {
        isFetchCalled = true
        return totalStatsToReturn
    }
    
    func fetchDailySales(receipts: [Receipt]) -> [DailySales]? {
        return dailySalesToReturn
    }
    
    func fetchTopItemSales(receipts: [Receipt], searchText: String?, limit: Int) -> [TopItemStat] {
        return topItemSalesToReturn ?? []
    }
}
