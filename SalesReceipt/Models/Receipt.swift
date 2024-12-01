//
//  Receipt.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import Foundation

struct Receipt: Identifiable {
    let id: UUID
    let date: Date
    var customerName: CustomerName
    var items: [Item]
    var total: Double {
        items.reduce(0) { $0 + $1.price.value }
    }
}

#warning("проверка на пустоту?")
struct CustomerName: Hashable {
    let value: String

    init(_ value: String? = nil) {
        guard let safeValue = value else {
            self.value = "Anonymous"
            return
        }
        self.value = safeValue
    }
}
