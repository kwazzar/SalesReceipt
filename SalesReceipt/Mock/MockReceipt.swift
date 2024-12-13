//
//  MockReceipt.swift
//  SalesReceipt
//
//  Created by Quasar on 12.12.2024.
//
import Foundation

// Пример данных для клиента
let testCustomerName1 = CustomerName("John Doe")
let testCustomerName2 = CustomerName("Jane Smith")

// Пример данных для товаров
let testItems1 = [
    Item(
        id: UUID(),
        description: Description("Apple iPhone 14"),
        price: Price(999.99),
        image: ImageItem("iphone_image_path")
    ),
    Item(
        id: UUID(),
        description: Description("Apple Watch Series 8"),
        price: Price(399.99),
        image: ImageItem("watch_image_path")
    )
]

let testItems2 = [
    Item(
        id: UUID(),
        description: Description("Samsung Galaxy S23"),
        price: Price(849.99),
        image: ImageItem("galaxy_image_path")
    ),
    Item(
        id: UUID(),
        description: Description("Samsung Galaxy Buds Pro"),
        price: Price(149.99),
        image: ImageItem("buds_image_path")
    )
]

// Пример данных для квитанций
let testReceipts = [
    Receipt(
        id: UUID(),
        date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
        customerName: testCustomerName1,
        items: testItems1
    ),
    Receipt(
        id: UUID(),
        date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
        customerName: testCustomerName2,
        items: testItems2
    )
]

