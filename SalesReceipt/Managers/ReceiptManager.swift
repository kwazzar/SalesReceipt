//
//  ReceiptManager.swift
//  SalesReceipt
//
//  Created by Quasar on 04.12.2024.
//

import Foundation

final class ReceiptManager: ReceiptDatabaseAPI {
    var availableItems: [Item] = mockItems
    private let database: SalesDatabaseProtocol

    init(database: SalesDatabaseProtocol) {
        self.database = database
    }

    func saveReceipt(customerName: CustomerName, items: [Item]) {
        let receipt = Receipt(
            id: UUID(),
            date: Date(),
            customerName: customerName,
            items: items
        )
        database.saveReceiptToDatabase(receipt)
    }

    func updatePDFPath(for receiptID: UUID, path: String) throws {
        try database.updatePdfPath(for: receiptID, pdfPath: path)
    }

    func fetchReceipt(by id: UUID) throws -> Receipt? {
        try fetchAllReceipts().first(where: { $0.id == id })
    }

    func fetchAllReceipts() throws -> [Receipt] {
        try database.fetchAllReceipts()
    }

    func clearAllReceipts() throws {
        try database.clearAllReceipts()
    }

    func filterReceipts(startDate: Date, endDate: Date, searchText: String) -> [Receipt] {
        Receipt.filter(
            to: (try? fetchAllReceipts()) ?? [],
            startDate: startDate,
            endDate: endDate,
            searchText: searchText
        )
    }

    func filter(receipts: [Receipt], startDate: Date, endDate: Date, searchText: String) -> [Receipt] {
        Receipt.filter(
            to: receipts,
            startDate: startDate,
            endDate: endDate,
            searchText: searchText
        )
    }

    func deleteReceipt(_ receipt: Receipt) throws {
        try database.deleteReceipt(receipt.id)
    }
}
