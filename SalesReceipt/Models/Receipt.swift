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

extension Receipt: Equatable, Hashable {
    static func == (lhs: Receipt, rhs: Receipt) -> Bool {
        lhs.id == rhs.id 
    }

    func hash(into hasher: inout Hasher) {
        // Додайте унікальні властивості для хешування
        hasher.combine(id) // припустимо, що є id
    }
}

//MARK: - Customer
enum CustomerType: Hashable {
    case anonymous
    case named(String)
}

struct CustomerName {
    let type: CustomerType

    init(_ value: String? = nil) {
        if let value = value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.type = .named(value)
        } else {
            self.type = .anonymous
        }
    }

    var value: String {
        switch type {
        case .anonymous:
            return "Anonymous"
        case .named(let name):
            return name
        }
    }
}

//MARK: - PdfPath
struct PdfPath: Hashable {
    let value: String

    init?(_ value: String?) {
        guard let value = value, !value.isEmpty else {
            return nil
        }
        self.value = value
    }
}
