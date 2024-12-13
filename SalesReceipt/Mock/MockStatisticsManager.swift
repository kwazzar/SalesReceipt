//
//  MockStatisticsManager.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import Foundation

final class MockStatisticsManager: StatisticsAPI {
    func getTotalSalesStats() -> (total: Double, itemsSold: Int, averageCheck: Double)? {
        return (total: 1000.0, itemsSold: 50, averageCheck: 20.0)
    }
    
    func getDailySalesStats() -> [SalesStat]? {
        return [
            SalesStat(date: Date().addingTimeInterval(-86400), totalAmount: 500.0, itemCount: 25),
            SalesStat(date: Date(), totalAmount: 235.0, itemCount: 25)
        ]
    }
    
    func getItemSalesStats() -> [Item: Int]? {
        let itemSales: [Int] = [5, 8, 12, 3, 7, 10, 4]
        
        var itemStats = [Item: Int]()
        for (index, item) in mockItems.enumerated() {
            itemStats[item] = itemSales[index]
        }
        return itemStats
    }
}
