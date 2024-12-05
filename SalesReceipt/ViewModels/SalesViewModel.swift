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

//final class SalesViewModel: ObservableObject {
//    @Published var isPopupVisible = false
//    @Published private(set) var filteredItems: [Item] = []
//    @Published var searchText: SearchQuery = SearchQuery(text: "")
//    @Published var customerName: CustomerName = CustomerName("")
//    @Published var showingDailySales = false
//
//    private let itemManager: ItemManager
//    private let receiptManager: ReceiptDatabaseAPI
//
//    init(itemManager: ItemManager = ItemManager(), receiptManager: ReceiptDatabaseAPI) {
//        self.itemManager = itemManager
//        self.receiptManager = receiptManager
//        self.filteredItems = mockItems
//    }
//
//    var currentItems: [Item] {
//        itemManager.items
//    }
//
//    var total: Price {
//        itemManager.total
//    }
//
//    func updateFilteredItems(for query: SearchQuery) {
//        filteredItems = Item.filter(items: mockItems, query: query)
//    }
//
//    func addItem(_ item: Item) {
//        itemManager.addItem(item)
//    }
//
//    func removeLastItem() {
//        itemManager.removeLastItem()
//    }
//
//    func clearAll() {
//        itemManager.clearAll()
//    }
//
//    func checkout() {
//        isPopupVisible = true
//    }
//
//    func finalizeCheckout(with name: String) {
//        guard !currentItems.isEmpty else {
//            isPopupVisible = false
//            return
//        }
//
//        let checkoutItems = currentItems
//        let checkoutName = CustomerName(name)
//        receiptManager.saveReceipt(customerName: checkoutName, items: checkoutItems)
//
//        clearAll()
//        isPopupVisible = false
//    }
//}


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

    func calculateTotal() {
        total = Item.calculateTotal(currentItems)
    }

    func removeLastItem() {
        Item.removeLastItem(from: &currentItems)
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
        guard !currentItems.isEmpty else {
            isPopupVisible = false
            return
        }

        let checkoutItems = currentItems
        let checkoutName = CustomerName(name)
        receiptManager.saveReceipt(customerName: checkoutName, items: checkoutItems)

        clearAll()
        isPopupVisible = false
    }
}
