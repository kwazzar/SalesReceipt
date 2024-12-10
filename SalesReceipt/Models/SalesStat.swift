//
//  SalesStat.swift
//  SalesReceipt
//
//  Created by Quasar on 09.12.2024.
//

import Foundation

struct SalesStat: Identifiable {
    let id = UUID()
    let date: Date
    let totalAmount: Double
    let itemCount: Int
}
