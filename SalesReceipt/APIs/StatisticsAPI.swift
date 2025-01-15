//
//  StatisticsAPI.swift
//  SalesReceipt
//
//  Created by Quasar on 15.01.2025.
//

import Foundation

protocol StatisticsAPI {
    func fetchTotalStats(receipts: [Receipt]) -> (total: Double, itemsSold: Int, averageCheck: Double)?
    func fetchDailySales(receipts: [Receipt]) -> [SalesStat]?
    func fetchTopItemSales(receipts: [Receipt], searchText: String?, limit: Int) -> [(item: Item, count: Int)]
}

extension StatisticsAPI {
    func calculateTotalItemCount(_ receipts: [Receipt]) -> Int {
        receipts.reduce(0) { total, receipt in
            total + receipt.items.reduce(0) { sum, item in
                sum + item.quantity
            }
        }
    }
}
