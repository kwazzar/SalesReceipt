//
//  Item.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import SwiftUI

protocol ItemProtocol: Hashable {
    associatedtype ItemType
    var value: ItemType {get}
}

struct Item: Identifiable, Hashable {
    let id: Int
    let description: String
    let price: Price
    var image: ImageItem
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

