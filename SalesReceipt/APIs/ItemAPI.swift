//
//  ItemAPI.swift
//  SalesReceipt
//
//  Created by Quasar on 15.01.2025.
//

import Foundation

protocol ItemManagerProtocol: ItemProvidable, ItemManagable {}

protocol ItemProvidable {
    var currentItems: [Item] { get }
    func filterItems(query: SearchQuery) -> [Item]
}

protocol ItemManagable {
    func addItem(_ item: Item)
    func deleteItem(_ item: Item)
    func decrementItem(_ item: Item)
    func clearAll()
    func calculateTotal() -> Price
}

//MARK: - AnyItemManager
final class AnyItemManager: ItemProvidable & ItemManagable {
    private let _currentItems: () -> [Item]
    private let _addItem: (Item) -> Void
    private let _deleteItem: (Item) -> Void
    private let _decrementItem: (Item) -> Void
    private let _clearAll: () -> Void
    private let _calculateTotal: () -> Price
    private let _filterItems: (SearchQuery) -> [Item]

    init<T: ItemProvidable & ItemManagable>(_ manager: T) {
        _currentItems = { manager.currentItems }
        _addItem = manager.addItem(_:)
        _deleteItem = manager.deleteItem(_:)
        _decrementItem = manager.decrementItem(_:)
        _clearAll = manager.clearAll
        _calculateTotal = manager.calculateTotal
        _filterItems = manager.filterItems(query:)
    }

    var currentItems: [Item] { _currentItems() }
    func addItem(_ item: Item) { _addItem(item) }
    func deleteItem(_ item: Item) { _deleteItem(item) }
    func decrementItem(_ item: Item) { _decrementItem(item) }
    func clearAll() { _clearAll() }
    func calculateTotal() -> Price { _calculateTotal() }
    func filterItems(query: SearchQuery) -> [Item] { _filterItems(query) }
}
