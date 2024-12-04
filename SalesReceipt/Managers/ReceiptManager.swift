//
//  ReceiptManager.swift
//  SalesReceipt
//
//  Created by Quasar on 04.12.2024.
//

import Foundation

protocol ReceiptDatabaseAPI {
    func saveReceipt(customerName: CustomerName, items: [Item])
    func updatePDFPath(for receiptID: UUID, path: String) throws
    func fetchReceipt(by id: UUID) -> Receipt?

}

final class ReceiptManager: ReceiptDatabaseAPI {
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
        database.saveReceipt(receipt)
    }

    func updatePDFPath(for receiptID: UUID, path: String) throws {
        try database.updatePdfPath(for: receiptID, pdfPath: path)
    }

    func fetchReceipt(by id: UUID) -> Receipt? {
        return database.fetchAllReceipts().first(where: { $0.id == id })
    }
}
