//
//  ReceiptDatabaseAPI.swift
//  SalesReceipt
//
//  Created by Quasar on 15.01.2025.
//

import Foundation

protocol ReceiptDatabaseAPI {
    var availableItems: [Item] { get set }
    func saveReceipt(customerName: CustomerName, items: [Item])
    func updatePDFPath(for receiptID: UUID, path: String) throws
    func fetchReceipt(by id: UUID) throws -> Receipt?
    func fetchAllReceipts() throws -> [Receipt]
    func clearAllReceipts() throws
    func filterReceipts(startDate: Date, endDate: Date, searchText: String) -> [Receipt]
    func filter(receipts: [Receipt], startDate: Date, endDate: Date, searchText: String) -> [Receipt]
    func deleteReceipt(_ receipt: Receipt) throws
}
