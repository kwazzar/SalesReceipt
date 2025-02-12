//
//  ReceiptDetailFactory.swift
//  SalesReceipt
//
//  Created by Quasar on 05.02.2025.
//

import Foundation

protocol ReceiptDetailFactory {
    func createReceiptDetailViewModel(receipt: Receipt) -> ReceiptDetailViewModel
    func createReceiptDetailView(receipt: Receipt) -> ReceiptDetailView
}
