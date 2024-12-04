//
//  SalesViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 02.11.2024.
//

import Foundation
import SwiftUI

struct SearchQuery {
    let text: String
}

let mockItems: [Item] = [
    Item(id: 1, description: "T-Shirt", price: Price(999.0), image: ImageItem("tshirt")),
    Item(id: 2, description: "Jeans", price: Price(2999.0), image: ImageItem("jeans")),
    Item(id: 3, description: "Sneakers", price: Price(4999.0), image: ImageItem("sneakers")),
    Item(id: 4, description: "Jacket", price: Price(7999.0), image: ImageItem("jacket")),
    Item(id: 5, description: "Hat", price: Price(499.0), image: ImageItem("hat")),
    Item(id: 6, description: "Backpack", price: Price(1999.0), image: ImageItem("backpack")),
    Item(id: 7, description: "Sunglasses", price: Price(699.0), image: ImageItem("sunglasses"))
]

final class SalesViewModel: ObservableObject {
    @Published private(set) var currentItems: [Item] = []
    @Published private(set) var total: Price = Price(0)
    @Published var customerName: CustomerName = CustomerName("")
    @Published var isPopupVisible = false
    @Published private(set) var filteredItems: [Item] = []
    @Published private(set) var availableItems: [Item] = mockItems
    @Published var searchText: SearchQuery = SearchQuery(text: "")
    @Published var isSearching = false
    @Published var showingDailySales = false

    private let receiptManager: ReceiptDatabaseAPI

    init(_ receiptManager: ReceiptDatabaseAPI) {
        self.receiptManager = receiptManager
        filteredItems = availableItems
    }

    func updateFilteredItems(for query: SearchQuery) {
        filteredItems = Item.filter(items: availableItems, query: query)
    }

    func addItem(_ item: Item) {
        currentItems.append(item)
        calculateTotal()
    }

    func removeLastItem() {
        guard !currentItems.isEmpty else { return }
        currentItems.removeLast()
        calculateTotal()
    }

    func clearAll() {
        currentItems.removeAll()
        customerName = CustomerName("")
        calculateTotal()
    }

    func checkout() {
        isPopupVisible = true
    }

    func finalizeCheckout(with name: String) {
        customerName = CustomerName(name)
        receiptManager.saveReceipt(customerName: customerName, items: currentItems)
        clearAll()
    }

    private func calculateTotal() {
        total = currentItems.reduce(Price(0)) { $0 + $1.price }
    }
}
