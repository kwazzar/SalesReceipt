//
//  CoordinatorContainer.swift
//  SalesReceipt
//
//  Created by Quasar on 05.02.2025.
//

import Foundation

protocol CoordinatorContainer {
    func createSalesView() -> SalesView
    func createDailySalesView() -> DailySalesView
    func createReceiptDetailView(receipt: Receipt) -> ReceiptDetailView
}
