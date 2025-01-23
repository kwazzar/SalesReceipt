//
//  SalesViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 02.11.2024.
//

import Foundation
import SwiftUI

final class SalesViewModel: ObservableObject {
    @Published private(set) var total: Price = Price(0)
    @Published var customerName: CustomerName = CustomerName("")

    #warning("need to specify the concrete type when initializing")
    private let itemManager: any ItemProvidable & ItemManagable
    private let checkoutManager: CheckoutManager
    let searchState: SearchState
    let uiState: SalesUIState
    
    init(
        receiptManager: ReceiptDatabaseAPI,
        itemManager: some ItemProvidable & ItemManagable
    ) {
        self.itemManager = itemManager
        self.checkoutManager = CheckoutManager(
            receiptManager: receiptManager,
            itemManager: itemManager
        )
        self.searchState = SearchState(itemProvider: itemManager)
        self.uiState = SalesUIState()
        self.searchState.setAvailableItems(receiptManager.availableItems)
    }
    
    var currentItems: [Item] {
        itemManager.currentItems
    }
    
    func addItem(_ item: Item) {
        itemManager.addItem(item)
        updateTotal()
    }
    
    func deleteItem(_ item: Item) {
        itemManager.deleteItem(item)
        updateTotal()
    }
    
    func decrementItem(_ item: Item) {
        itemManager.decrementItem(item)
        updateTotal()
    }
    
    func clearAll() {
        itemManager.clearAll()
        customerName = CustomerName("")
        updateTotal()
    }
    
    private func updateTotal() {
        total = itemManager.calculateTotal()
    }
    
    func checkout() {
        uiState.isPopupVisible = true
    }
    
    func finalizeCheckout(with name: String) {
        if checkoutManager.finalizeCheckout(customerName: name) {
            customerName = CustomerName("")
            updateTotal()
            uiState.isPopupVisible = false
        }
    }
}

//MARK: - SearchState
struct SearchQuery {
    let text: String
}

final class SearchState: ObservableObject {
    @Published var searchText: SearchQuery = SearchQuery(text: "")
    @Published var isSearching = false
    @Published var filteredItems: [Item] = []
    
    private let itemProvider: ItemProvidable
    private var availableItems: [Item] = []
    
    init(itemProvider: some ItemProvidable) {
        self.itemProvider = itemProvider
    }
    
    func setAvailableItems(_ items: [Item]) {
        self.availableItems = items
        self.filteredItems = items
    }
    
    func updateFilteredItems(for query: SearchQuery) {
        if query.text.isEmpty {
            filteredItems = availableItems
        } else {
            filteredItems = availableItems.filter { item in
                item.description.value
                    .localizedCaseInsensitiveContains(query.text)
            }
        }
    }
}

//MARK: - SalesUIState
final class SalesUIState: ObservableObject {
    @Published var isPopupVisible = false
    @Published var showingDailySales = false
    @Published var activeMenuItemID: UUID? = nil
}

//MARK: - CheckoutManager
final class CheckoutManager {
    private let receiptManager: ReceiptDatabaseAPI
    private let itemManager: any ItemProvidable & ItemManagable
    
    init(receiptManager: ReceiptDatabaseAPI, itemManager: some ItemProvidable & ItemManagable) {
        self.receiptManager = receiptManager
        self.itemManager = itemManager
    }

    func finalizeCheckout(customerName: String) -> Bool {
        guard !itemManager.currentItems.isEmpty else {
            return false
        }
        
        let checkoutItems = itemManager.currentItems
        let checkoutName = CustomerName(customerName)
        receiptManager.saveReceipt(customerName: checkoutName, items: checkoutItems)
        
        itemManager.clearAll()
        return true
    }
}
