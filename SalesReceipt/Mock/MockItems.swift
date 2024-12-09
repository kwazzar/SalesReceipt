//
//  MockItems.swift
//  SalesReceipt
//
//  Created by Quasar on 05.12.2024.
//

import Foundation

#warning("давати id потрібно пізніше коли вони додаються в чек")
let mockItems: [Item] = [
    Item(id: UUID(), description: Description("T-Shirt"), price: Price(999.0), image: ImageItem("tshirt")),
    Item(id: UUID(), description: Description("Jeans"), price: Price(2999.0), image: ImageItem("jeans")),
    Item(id: UUID(), description: Description("Sneakers"), price: Price(4999.0), image: ImageItem("sneakers")),
    Item(id: UUID(), description: Description("Jacket"), price: Price(7999.0), image: ImageItem("jacket")),
    Item(id: UUID(), description: Description("Hat"), price: Price(499.0), image: ImageItem("hat")),
    Item(id: UUID(), description: Description("Backpack"), price: Price(1999.0), image: ImageItem("backpack")),
    Item(id: UUID(), description: Description("Sunglasses"), price: Price(699.0), image: ImageItem("sunglasses"))
]
