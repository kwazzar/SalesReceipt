//
//  StatisticsManager.swift
//  SalesReceipt
//
//  Created by Quasar on 09.12.2024.
//

import Foundation

final class StatisticsManager: StatisticsAPI {
    internal func fetchTotalStats(receipts: [Receipt]) -> TotalStats? {
        guard !receipts.isEmpty else { return nil }
        
        let totalAmount = receipts.reduce(0) { $0 + $1.total }
        let totalItems = calculateTotalItemCount(receipts)
        let averageCheck = totalAmount / Double(receipts.count)
        
        return TotalStats(total: totalAmount, itemsSold: totalItems, averageCheck: averageCheck)
    }
    
    internal func fetchDailySales(receipts: [Receipt]) -> [DailySales]? {
        guard !receipts.isEmpty else { return nil }
        
        let calendar = Calendar.current
        let groupedReceipts = Dictionary(grouping: receipts) { receipt in
            calendar.startOfDay(for: receipt.date)
        }
        
        return groupedReceipts.map { date, dayReceipts in
            let totalAmount = dayReceipts.reduce(0) { $0 + $1.total }
            let itemCount = dayReceipts.reduce(0) { total, receipt in
                total + receipt.items.reduce(0) { $0 + $1.quantity }
            }
            
            return DailySales(date: date, totalAmount: totalAmount, itemCount: itemCount)
        }.sorted { $0.date < $1.date }
    }
    
    internal func fetchTopItemSales(receipts: [Receipt],
                                    searchText: String? = nil,
                                    limit: Int = 5) -> [TopItemStat] {
        var filteredReceipts = receipts
        // Если есть текст поиска, фильтруем сначала рецепты
        if let searchText = searchText, !searchText.isEmpty {
            filteredReceipts = receipts.filter { receipt in
                receipt.items.contains {
                    $0.description.value.lowercased().contains(searchText.lowercased())
                }
            }
        }
        
        let filteredItems = filteredReceipts.flatMap { $0.items }
        var itemStats = [Item: Int]()
        for item in filteredItems {
            // Use the first matching item as the key and accumulate quantities
            if let existingItem = itemStats.keys.first(where: { $0.description == item.description }) {
                itemStats[existingItem, default: 0] += item.quantity
            } else {
                // Create a new item with quantity = 1 for the key, but store the actual quantity
                let keyItem = Item(
                    id: item.id ?? UUID(),
                    description: item.description,
                    price: item.price,
                    image: item.image,
                    quantity: 1
                )
                itemStats[keyItem] = item.quantity
            }
        }
        
        return itemStats
            .sorted { $0.value > $1.value }
            .prefix(limit)
            .map { TopItemStat(item: $0.key, count: $0.value) }
    }
}
