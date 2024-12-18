//
//  StatisticsManager.swift
//  SalesReceipt
//
//  Created by Quasar on 09.12.2024.
//

import Foundation

protocol StatisticsAPI {
    func fetchTotalStats(receipts: [Receipt]) -> (total: Double, itemsSold: Int, averageCheck: Double)?
    func fetchDailySales(receipts: [Receipt]) -> [SalesStat]?
    func fetchTopItemSales(receipts: [Receipt], searchText: String?, limit: Int) -> [(item: Item, count: Int)]
}

final class StatisticsManager: StatisticsAPI {
    internal func fetchTotalStats(receipts: [Receipt]) -> (total: Double, itemsSold: Int, averageCheck: Double)? {
        guard !receipts.isEmpty else { return nil }

        let totalAmount = receipts.reduce(0) { $0 + $1.total }
        let totalItems = receipts.flatMap { $0.items }.count
        let averageCheck = totalAmount / Double(receipts.count)

        return (totalAmount, totalItems, averageCheck)
    }

    internal func fetchDailySales(receipts: [Receipt]) -> [SalesStat]? {
        guard !receipts.isEmpty else { return nil }

        let calendar = Calendar.current

        let groupedReceipts = Dictionary(grouping: receipts) { receipt in
            calendar.startOfDay(for: receipt.date)
        }

        return groupedReceipts.map { date, dayReceipts in
            let totalAmount = dayReceipts.reduce(0) { $0 + $1.total }
            let itemCount = dayReceipts.flatMap { $0.items }.count

            return SalesStat(date: date, totalAmount: totalAmount, itemCount: itemCount)
        }.sorted { $0.date < $1.date }
    }

    internal func fetchTopItemSales(receipts: [Receipt], searchText: String? = nil, limit: Int = 5) -> [(item: Item, count: Int)] {
        print("🏆 Получение топ продаж")
        print("🧾 Количество рецептов: \(receipts.count)")
        print("🔍 Текст поиска: \(searchText ?? "Нет")")

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

        print("🛍️ Количество рецептов после фильтрации: \(filteredReceipts.count)")
        print("🛍️ Количество товаров после фильтрации: \(filteredItems.count)")

        var itemStats = [Item: Int]()
        for item in filteredItems {
            itemStats[item, default: 0] += 1
        }

        let result = itemStats
            .sorted { $0.value > $1.value }
            .prefix(limit)
            .map { (item: $0.key, count: $0.value) }

        print("📊 Топ товаров:")
        for (index, item) in result.enumerated() {
            print("  \(index + 1). \(item.item.description.value): \(item.count)")
        }

        return result
    }
}
