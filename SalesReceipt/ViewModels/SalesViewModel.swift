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

final class SalesViewModel: ObservableObject {
    @Published private(set) var currentItems: [Item] = []
    @Published private(set) var total: Price = Price(0)
    @Published private(set) var filteredItems: [Item] = []
    @Published var customerName: CustomerName = CustomerName("")
    @Published var searchText: SearchQuery = SearchQuery(text: "")
    @Published var isPopupVisible = false
    @Published var isSearching = false
    @Published var showingDailySales = false
    
    private let receiptManager: ReceiptDatabaseAPI
    
    init(_ receiptManager: ReceiptDatabaseAPI) {
        self.receiptManager = receiptManager
        filteredItems = receiptManager.availableItems
    }
    
    func updateFilteredItems(for query: SearchQuery) {
        filteredItems = Item.filter(items: receiptManager.availableItems, query: query)
    }
    
    func addItem(_ item: Item) {
        let receiptItem = Item(
            id: UUID(),
            description: item.description,
            price: item.price,
            image: item.image
        )
        currentItems.append(receiptItem)
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
