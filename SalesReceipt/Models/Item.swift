//
//  Item.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import SwiftUI

struct Item: Identifiable, Hashable {
    let id: UUID?
    let description: Description
    let price: Price
    var image: ImageItem

    // Initialize without ID for catalog items
    init(description: Description, price: Price, image: ImageItem) {
        self.id = nil
        self.description = description
        self.price = price
        self.image = image
    }

    // Initialize with ID for receipt items
    init(id: UUID = UUID(), description: Description, price: Price, image: ImageItem) {
        self.id = id
        self.description = description
        self.price = price
        self.image = image
    }

    static func filter(items: [Item], query: SearchQuery) -> [Item] {
        return query.text.isEmpty
        ? items
        : items.filter { $0.description.value.lowercased().contains(query.text.lowercased()) }
    }

    static func calculateTotal(_ items: [Item]) -> Price {
        return items.reduce(Price(0)) { $0 + $1.price }
    }

    static func removeLastItem(from items: inout [Item]) {
        guard !items.isEmpty else { return }
        items.removeLast()
    }
}

//MARK: - Item properties
protocol ItemProtocol: Hashable {
    associatedtype ItemType
    var value: ItemType {get}
}

struct Description: ItemProtocol {
    let value: String

    init(_ value: String? = nil) {
        guard let safeValue = value, !safeValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.value = "no Description"
            return
        }
        self.value = safeValue
    }
}

struct Price: ItemProtocol {
    let value: Double

    init(_ value: Double) {
        self.value = value
    }

    static func +(lhs: Price, rhs: Price) -> Price {
        return Price(lhs.value + rhs.value)
    }
}

struct ImageItem: ItemProtocol {
    let value: String

    init(_ value: String? = nil) {
        guard let value = value, UIImage(systemName: value) != nil else {
            self.value = "cart" // Fallback to "cart" if the image name is nil or invalid
            return
        }
        self.value = value
    }
}
