//
//  Receipt.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import Foundation

struct Receipt: Identifiable {
    let id: UUID
    let date: Date
    var customerName: CustomerName
    var items: [Item]
    var pdfPath: PdfPath?
    var total: Double {
        items.reduce(0) { $0 + ($1.price.value * Double($1.quantity)) }
    }
    
    static func filter(
        to receipts: [Receipt],
        startDate: Date,
        endDate: Date,
        searchText: String
    ) -> [Receipt] {
        let dateFiltered = receipts.filter { receipt in
            receipt.date >= startDate && receipt.date <= endDate
        }

        guard !searchText.isEmpty else {
            return dateFiltered
        }

        return dateFiltered.filter { receipt in
            receipt.customerName.value.lowercased().contains(searchText.lowercased()) ||
            receipt.items.contains { item in
                item.description.value.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

extension Receipt: Equatable {
    static func == (lhs: Receipt, rhs: Receipt) -> Bool {
        lhs.id == rhs.id 
    }
}

struct CustomerName: Hashable {
    let value: String

    init(_ value: String? = nil) {
        guard let safeValue = value, !safeValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.value = "Anonymous"
            return
        }
        self.value = safeValue
    }
}

struct PdfPath: Hashable {
    let value: String

    init?(_ value: String?) {
        guard let value = value, !value.isEmpty else {
            return nil
        }
        self.value = value
    }
}
