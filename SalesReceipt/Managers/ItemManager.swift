//
//  ItemManager.swift
//  SalesReceipt
//
//  Created by Quasar on 29.12.2024.
//

import Foundation

final class ItemManager: ItemManagerProtocol {
    private(set) var currentItems: [Item] = []
    
    func addItem(_ item: Item) {
        if let index = currentItems.firstIndex(where: { $0.description == item.description }) {
            currentItems[index].quantity += 1
        } else {
            let receiptItem = Item(
                id: UUID(),
                description: item.description,
                price: item.price,
                image: item.image,
                quantity: 1
            )
            currentItems.append(receiptItem)
        }
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
    
    func calculateTotal() -> Price {
        return currentItems.reduce(Price(0)) { total, item in
            total + Price(item.price.value * Double(item.quantity))
        }
    }
    
    func filterItems(query: SearchQuery) -> [Item] {
        return query.text.isEmpty
        ? currentItems
        : currentItems.filter { $0.description.value.lowercased().contains(query.text.lowercased()) }
    }
    
    func clearAll() {
        currentItems.removeAll()
    }
}


