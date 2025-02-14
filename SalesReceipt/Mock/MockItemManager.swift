//
//  MockItemManager.swift
//  SalesReceipt
//
//  Created by Quasar on 14.02.2025.
//

import Foundation


final class MockItemManager: ItemManagerProtocol {
    private(set) var currentItems: [Item] = []

    func addItem(_ item: Item) {
        currentItems.append(item)
    }

    func deleteItem(_ item: Item) {
        currentItems.removeAll(where: { $0.id == item.id })
    }

    func decrementItem(_ item: Item) {
        if let index = currentItems.firstIndex(where: { $0.id == item.id }) {
            if currentItems[index].quantity > 1 {
                currentItems[index].quantity -= 1
            } else {
                currentItems.removeAll(where: { $0.id == item.id })
            }
        }
    }

    func clearAll() {
        currentItems.removeAll()
    }

    func calculateTotal() -> Price {
        return currentItems.reduce(Price(0)) { total, item in
            total + Price(item.price.value * Double(item.quantity))
        }
    }

    func filterItems(query: SearchQuery) -> [Item] {
        return []
    }
}
