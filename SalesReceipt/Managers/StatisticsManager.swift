//
//  StatisticsManager.swift
//  SalesReceipt
//
//  Created by Quasar on 09.12.2024.
//

import Foundation

protocol StatisticsAPI {
    func getTotalSalesStats() -> (total: Double, itemsSold: Int, averageCheck: Double)?
    func getDailySalesStats() -> [SalesStat]?
    func getItemSalesStats() -> [Item: Int]?
}

final class StatisticsManager: StatisticsAPI {
    static let shared = StatisticsManager()
    private let database = SalesDatabase.shared
    
    func getTotalSalesStats() -> (total: Double, itemsSold: Int, averageCheck: Double)? {
        do {
            let receipts = try database.fetchAllReceipts()
            let totalAmount = receipts.reduce(0) { $0 + $1.total }
            let totalItems = receipts.flatMap { $0.items }.count
            let averageCheck = totalAmount / Double(max(receipts.count, 1))
            
            return (totalAmount, totalItems, averageCheck)
        } catch {
            print("Failed to fetch receipts: \(error)")
            return nil
        }
    }
    
    func getDailySalesStats() -> [SalesStat]? {
        do {
            let receipts = try database.fetchAllReceipts()
            
            let calendar = Calendar.current
            let groupedReceipts = Dictionary(grouping: receipts) { receipt in
                calendar.startOfDay(for: receipt.date)
            }
            
            return groupedReceipts.map { date, dayReceipts in
                let totalAmount = dayReceipts.reduce(0) { $0 + $1.total }
                let itemCount = dayReceipts.flatMap { $0.items }.count
                
                return SalesStat(date: date, totalAmount: totalAmount, itemCount: itemCount)
            }.sorted { $0.date < $1.date }
        } catch {
            print("Failed to fetch receipts: \(error)")
            return nil
        }
    }
    
    func getItemSalesStats() -> [Item: Int]? {
        do {
            let receipts = try database.fetchAllReceipts()
            let allItems = receipts.flatMap { $0.items }
            
            var itemStats = [Item: Int]()
            for item in allItems {
                itemStats[item, default: 0] += 1
            }
            
            return itemStats
        } catch {
            print("Failed to fetch receipts: \(error)")
            return nil
        }
    }
}
