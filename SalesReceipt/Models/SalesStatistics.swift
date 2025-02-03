//
//  SalesStatistics.swift
//  SalesReceipt
//
//  Created by Quasar on 09.12.2024.
//

import Foundation

// MARK: - Daily Sales
struct DailySales: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let sales: Sales
    
    init(date: Date, totalAmount: Double, itemCount: Int) {
        self.date = date
        self.sales = Sales(total: totalAmount, itemCount: itemCount)
    }
    
    var totalAmount: Double { sales.total }
    var itemCount: Int { sales.itemCount }
}

// MARK: - Total Stats
struct TotalStats: Equatable {
    let sales: Sales
    let averageCheck: Money
    
    init(total: Double, itemsSold: Int, averageCheck: Double) {
        self.sales = Sales(total: total, itemCount: itemsSold)
        self.averageCheck = Money(amount: averageCheck)
    }
    
    var total: Double { sales.total }
    var itemsSold: Int { sales.itemCount }
}

// MARK: - Top Item Stats
struct TopItemStat: Equatable {
    let item: Item
    let quantity: Quantity
    
    init(item: Item, count: Int) {
        self.item = item
        self.quantity = Quantity(count)
    }
    
    var count: Int { quantity.value }
}

// MARK: - Value Objects
struct Sales: Equatable {
    let total: Double
    let itemCount: Int
    
    init(total: Double, itemCount: Int) {
        self.total = total
        self.itemCount = itemCount
    }
}

struct Money: Equatable {
    let amount: Double
    
    init(amount: Double) {
        self.amount = amount
    }
    
    var formatted: String {
        String(format: "%.2f ₴", amount)
    }
}

struct Quantity: Equatable {
    let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
    
    var formatted: String {
        "\(value)"
    }
}
