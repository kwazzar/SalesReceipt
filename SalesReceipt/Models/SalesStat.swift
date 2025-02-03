//
//  SalesStat.swift
//  SalesReceipt
//
//  Created by Quasar on 09.12.2024.
//

import Foundation

struct DailySales: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let totalAmount: Double
    let itemCount: Int
}

struct TotalStats: Equatable {
    let total: Double
    let itemsSold: Int
    let averageCheck: Double
}

struct TopItemStat: Equatable {
    let item: Item
    let count: Int
}
