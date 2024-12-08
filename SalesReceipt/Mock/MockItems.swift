//
//  MockItems.swift
//  SalesReceipt
//
//  Created by Quasar on 05.12.2024.
//

import Foundation

let mockItems: [Item] = [
    Item(id: 1, description: Description("T-Shirt"), price: Price(999.0), image: ImageItem("tshirt")),
    Item(id: 2, description: Description("Jeans"), price: Price(2999.0), image: ImageItem("jeans")),
    Item(id: 3, description: Description("Sneakers"), price: Price(4999.0), image: ImageItem("sneakers")),
    Item(id: 4, description: Description("Jacket"), price: Price(7999.0), image: ImageItem("jacket")),
    Item(id: 5, description: Description("Hat"), price: Price(499.0), image: ImageItem("hat")),
    Item(id: 6, description: Description("Backpack"), price: Price(1999.0), image: ImageItem("backpack")),
    Item(id: 7, description: Description("Sunglasses"), price: Price(699.0), image: ImageItem("sunglasses"))
]
