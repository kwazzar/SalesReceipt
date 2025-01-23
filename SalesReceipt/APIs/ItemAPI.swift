//
//  ItemAPI.swift
//  SalesReceipt
//
//  Created by Quasar on 15.01.2025.
//

import Foundation

#warning("підписання протоколів під один обьект")
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
