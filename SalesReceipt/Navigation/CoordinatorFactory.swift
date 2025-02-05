//
//  CoordinatorFactory.swift
//  SalesReceipt
//
//  Created by Quasar on 05.02.2025.
//

import Foundation

protocol CoordinatorFactory {
    func createSalesView() -> SalesView
    func createDailySalesView() -> DailySalesView
    func createReceiptDetailView(receipt: Receipt) -> ReceiptDetailView
}
