//
//  Item.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import SwiftUI
#warning("id change to uuid")
struct Item: Identifiable, Hashable {
    let id: Int
    let description: String
    let price: Price
    var image: ImageItem

    static func filter(items: [Item], query: SearchQuery) -> [Item] {
           return query.text.isEmpty
               ? items
               : items.filter { $0.description.lowercased().contains(query.text.lowercased()) }
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

#warning("Description")
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
