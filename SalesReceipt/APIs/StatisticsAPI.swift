//
//  StatisticsAPI.swift
//  SalesReceipt
//
//  Created by Quasar on 15.01.2025.
//

import Foundation

protocol StatisticsAPI {
    func fetchTotalStats(receipts: [Receipt]) -> TotalStats?
    func fetchDailySales(receipts: [Receipt]) -> [DailySales]?
    func fetchTopItemSales(receipts: [Receipt], searchText: String?, limit: Int) -> [TopItemStat]
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
