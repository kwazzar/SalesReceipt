//
//  MockSalesDatabase.swift
//  SalesReceipt
//
//  Created by Quasar on 12.12.2024.
//

import Foundation
final class MockSalesDatabase: SalesDatabaseProtocol {
    var receipts: [Receipt] = testReceipts

    func saveReceiptToDatabase(_ receipt: Receipt) {
        receipts.append(receipt)
    }

    func fetchAllReceipts() throws -> [Receipt] {
        return receipts
    }

    func clearAllReceipts() throws {
        receipts.removeAll()
    }

    func updatePdfPath(for receiptId: UUID, pdfPath: String) throws {
        if let index = receipts.firstIndex(where: { $0.id == receiptId }) {
            receipts[index].pdfPath = PdfPath(pdfPath)
        } else {
            throw DatabaseError.updatePDFPathFailed(reason: .receiptNotFound)
        }
    }

    func deleteReceipt(_ receiptId: UUID) throws {
        receipts.removeAll { $0.id == receiptId }
    }
}
