//
//  MockStatisticsManager.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import Foundation

final class MockStatisticsManager: StatisticsAPI {
    func fetchTotalStats() -> (total: Double, itemsSold: Int, averageCheck: Double)? {
        return (total: 1000.0, itemsSold: 50, averageCheck: 20.0)
    }
    
    func fetchDailySales() -> [SalesStat]? {
        return [
            SalesStat(date: Date().addingTimeInterval(-86400), totalAmount: 500.0, itemCount: 25),
            SalesStat(date: Date(), totalAmount: 235.0, itemCount: 25)
        ]
    }
    
    func fetchTopItemSales() -> [Item: Int]? {
        let itemSales: [Int] = [5, 8, 12, 3, 7, 10, 4]
        
        var itemStats = [Item: Int]()
        for (index, item) in mockItems.enumerated() {
            itemStats[item] = itemSales[index]
        }
        return itemStats
    }
    
    func fetchTopItemSales(limit: Int = 5) -> [(item: Item, count: Int)] {
        guard let itemStats = fetchTopItemSales() else { return [] }
        
        return itemStats
            .sorted { $0.value > $1.value }
            .prefix(limit)
            .map { (item: $0.key, count: $0.value) }
    }
}

