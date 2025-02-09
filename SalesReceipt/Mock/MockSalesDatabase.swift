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

    func fetchLastReceipts(limit: Int) throws -> [Receipt] {
        return Array(receipts.sorted { $0.date > $1.date }.prefix(limit))
    }

    func fetchAllReceipts() async throws -> [Receipt] {
        // Симулюємо асинхронну затримку для реалістичності
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds delay
        return receipts.sorted { $0.date > $1.date }
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
        guard receipts.contains(where: { $0.id == receiptId }) else {
            throw DatabaseError.deleteReceiptFailed(reason: .receiptNotFound)
        }
        receipts.removeAll { $0.id == receiptId }
    }
}
