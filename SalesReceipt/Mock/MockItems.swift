//
//  MockItems.swift
//  SalesReceipt
//
//  Created by Quasar on 05.12.2024.
//

import Foundation

let mockItems: [Item] = [
    Item(description: Description("T-Shirt"), price: Price(999.0), image: ImageItem("tshirt")),
    Item(description: Description("Jeans"), price: Price(2999.0), image: ImageItem("jeans")),
    Item(description: Description("Sneakers"), price: Price(4999.0), image: ImageItem("sneakers")),
    Item(description: Description("Jacket"), price: Price(7999.0), image: ImageItem("jacket")),
    Item(description: Description("Hat"), price: Price(499.0), image: ImageItem("hat")),
    Item(description: Description("Backpack"), price: Price(1999.0), image: ImageItem("backpack")),
    Item(description: Description("Sunglasses"), price: Price(699.0), image: ImageItem("sunglasses"))
]

let testItems1 = [
    Item(id: UUID(), description: Description("Apple iPhone 14"), price: Price(999.99), image: ImageItem("iphone_image_path"), quantity: 7),
    Item(id: UUID(), description: Description("Apple Watch Series 8"), price: Price(399.99), image: ImageItem("watch_image_path"), quantity: 1),
    Item(id: UUID(), description: Description("Samsung Galaxy S23"), price: Price(849.99), image: ImageItem("galaxy_image_path"), quantity: 10)
]

let testItems2 = [
    Item(id: UUID(), description: Description("Apple iPhone 14"), price: Price(999.99), image: ImageItem("iphone_image_path"), quantity: 4),
    Item(id: UUID(), description: Description("Sony WH-1000XM5"), price: Price(349.99), image: ImageItem("sony_headphones_image_path"), quantity: 8),
    Item(id: UUID(), description: Description("Apple Watch Series 8"), price: Price(399.99), image: ImageItem("watch_image_path"), quantity: 3)
]

let testItems3 = [
    Item(id: UUID(), description: Description("Samsung Galaxy S23"), price: Price(849.99), image: ImageItem("galaxy_image_path"), quantity: 9),
    Item(id: UUID(), description: Description("Google Pixel 7"), price: Price(599.99), image: ImageItem("pixel_image_path"), quantity: 2),
    Item(id: UUID(), description: Description("Apple iPhone 14"), price: Price(999.99), image: ImageItem("iphone_image_path"), quantity: 6)
]

let testItems4 = [
    Item(id: UUID(), description: Description("Microsoft Surface Pro 9"), price: Price(999.99), image: ImageItem("surface_pro_image_path"), quantity: 5),
    Item(id: UUID(), description: Description("Samsung Galaxy S23"), price: Price(849.99), image: ImageItem("galaxy_image_path"), quantity: 3),
    Item(id: UUID(), description: Description("Apple Watch Series 8"), price: Price(399.99), image: ImageItem("watch_image_path"), quantity: 7)
]

let testItems5 = [
    Item(id: UUID(), description: Description("Apple iPhone 14"), price: Price(999.99), image: ImageItem("iphone_image_path"), quantity: 8),
    Item(id: UUID(), description: Description("Samsung Galaxy S23"), price: Price(849.99), image: ImageItem("galaxy_image_path"), quantity: 4),
    Item(id: UUID(), description: Description("Sony WH-1000XM5"), price: Price(349.99), image: ImageItem("sony_headphones_image_path"), quantity: 1)
]

let testItems6 = [
    Item(id: UUID(), description: Description("Apple MacBook Air M2"), price: Price(1199.99), image: ImageItem("macbook_air_image_path"), quantity: 3),
    Item(id: UUID(), description: Description("Apple iPhone 14"), price: Price(999.99), image: ImageItem("iphone_image_path"), quantity: 6),
    Item(id: UUID(), description: Description("Samsung Galaxy S23"), price: Price(849.99), image: ImageItem("galaxy_image_path"), quantity: 4)
]

let testItems7 = [
    Item(id: UUID(), description: Description("Apple Watch Series 8"), price: Price(399.99), image: ImageItem("watch_image_path"), quantity: 5),
    Item(id: UUID(), description: Description("Google Pixel 7"), price: Price(599.99), image: ImageItem("pixel_image_path"), quantity: 7),
    Item(id: UUID(), description: Description("Apple iPhone 14"), price: Price(999.99), image: ImageItem("iphone_image_path"), quantity: 2)
]

let testItems8 = [
    Item(id: UUID(), description: Description("Sony PlayStation 5"), price: Price(499.99), image: ImageItem("ps5_image_path"), quantity: 3),
    Item(id: UUID(), description: Description("Apple Watch Series 8"), price: Price(399.99), image: ImageItem("watch_image_path"), quantity: 4),
    Item(id: UUID(), description: Description("Apple MacBook Air M2"), price: Price(1199.99), image: ImageItem("macbook_air_image_path"), quantity: 6)
]

let testItems9 = [
    Item(id: UUID(), description: Description("Dell XPS 13"), price: Price(999.99), image: ImageItem("dell_xps_image_path"), quantity: 9),
    Item(id: UUID(), description: Description("Apple Watch Series 8"), price: Price(399.99), image: ImageItem("watch_image_path"), quantity: 5),
    Item(id: UUID(), description: Description("Microsoft Surface Pro 9"), price: Price(999.99), image: ImageItem("surface_pro_image_path"), quantity: 3)
]

let testItems10 = [
    Item(id: UUID(), description: Description("Google Nest Hub"), price: Price(89.99), image: ImageItem("nest_hub_image_path"), quantity: 8),
    Item(id: UUID(), description: Description("Samsung Galaxy S23"), price: Price(849.99), image: ImageItem("galaxy_image_path"), quantity: 2),
    Item(id: UUID(), description: Description("Sony WH-1000XM5"), price: Price(349.99), image: ImageItem("sony_headphones_image_path"), quantity: 5)
]
