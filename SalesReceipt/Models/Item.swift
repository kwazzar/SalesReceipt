//
//  Item.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import SwiftUI
struct Item: Identifiable, Hashable, Equatable {
    let id: UUID?
    let description: Description
    let price: Price
    var image: ImageItem
    var quantity: Int = 1
    
    init(id: UUID = UUID(), description: Description, price: Price, image: ImageItem, quantity: Int = 1) {
        self.id = id
        self.description = description
        self.price = price
        self.image = image
        self.quantity = quantity
    }
}

//MARK: - Item properties
protocol ItemProtocol: Hashable {
    associatedtype ItemType
    var value: ItemType {get}
}

struct Description: ItemProtocol {
    let value: String
    
    init(_ value: String? = nil) {
        guard let safeValue = value, !safeValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.value = "no Description"
            return
        }
        self.value = safeValue
    }
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
