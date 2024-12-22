//
//  MockReceiptManager.swift
//  SalesReceipt
//
//  Created by Quasar on 15.12.2024.
//

import Foundation

final class MockReceiptManager: ReceiptDatabaseAPI {

    var availableItems: [Item] = testItems1 + testItems2
    private var storedReceipts: [Receipt] = testReceipts
    
    func saveReceipt(customerName: CustomerName, items: [Item]) {
        let newReceipt = Receipt(
            id: UUID(),
            date: Date(),
            customerName: customerName,
            items: items
        )
        storedReceipts.append(newReceipt)
    }
    
    func updatePDFPath(for receiptID: UUID, path: String) throws {
        guard storedReceipts.firstIndex(where: { $0.id == receiptID }) != nil else {
            throw NSError(domain: "MockReceiptManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Receipt not found"])
        }
        // В реальном сценарии здесь бы обновлялся PDF-путь
    }
    
    func fetchReceipt(by id: UUID) throws -> Receipt? {
        return storedReceipts.first(where: { $0.id == id })
    }
    
    func fetchAllReceipts() throws -> [Receipt] {
        return storedReceipts
    }
    
    func clearAllReceipts() throws {
        storedReceipts.removeAll()
    }
    
    func filterReceipts(startDate: Date, endDate: Date, searchText: String) -> [Receipt] {
        return storedReceipts.filter { receipt in
            let dateInRange = receipt.date >= startDate && receipt.date <= endDate
            let matchesSearchText = searchText.isEmpty ||
            receipt.customerName.value.localizedCaseInsensitiveContains(searchText) ||
            receipt.items.contains { item in
                item.description.value.localizedCaseInsensitiveContains(searchText)
            }
            
            return dateInRange && matchesSearchText
        }
    }

    func filter(receipts: [Receipt], startDate: Date, endDate: Date, searchText: String) -> [Receipt] {
        Receipt.filter(
            to: receipts,
            startDate: startDate,
            endDate: endDate,
            searchText: searchText
        )
    }
}
