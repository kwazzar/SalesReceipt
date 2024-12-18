//
//  MockReceipt.swift
//  SalesReceipt
//
//  Created by Quasar on 12.12.2024.
//
import Foundation

let testCustomerName1 = CustomerName("John Doe")
let testCustomerName2 = CustomerName("Jane Smith")
let testCustomerName3 = CustomerName("Alice Johnson")
let testCustomerName4 = CustomerName("Bob Brown")
let testCustomerName5 = CustomerName("Charlie Davis")
let testCustomerName6 = CustomerName("Diana Evans")
let testCustomerName7 = CustomerName("Ethan Foster")
let testCustomerName8 = CustomerName("Fiona Green")
let testCustomerName9 = CustomerName("George Harris")
let testCustomerName10 = CustomerName("Hannah Ivers")

let testItems1 = [
    Item(id: UUID(), description: Description("Apple iPhone 14"), price: Price(999.99), image: ImageItem("iphone_image_path")),
    Item(id: UUID(), description: Description("Apple Watch Series 8"), price: Price(399.99), image: ImageItem("watch_image_path"))
]

let testItems2 = [
    Item(id: UUID(), description: Description("Samsung Galaxy S23"), price: Price(849.99), image: ImageItem("galaxy_image_path")),
    Item(id: UUID(), description: Description("Samsung Galaxy Buds Pro"), price: Price(149.99), image: ImageItem("buds_image_path"))
]

let testItems3 = [
    Item(id: UUID(), description: Description("Google Pixel 7"), price: Price(599.99), image: ImageItem("pixel_image_path")),
    Item(id: UUID(), description: Description("Google Nest Hub"), price: Price(89.99), image: ImageItem("nest_hub_image_path"))
]

let testItems4 = [
    Item(id: UUID(), description: Description("OnePlus 11"), price: Price(699.99), image: ImageItem("oneplus_image_path")),
    Item(id: UUID(), description: Description("OnePlus Buds Pro"), price : Price(149.99), image : ImageItem("oneplus_buds_image_path"))
]

let testItems5 = [
    Item(id : UUID(), description : Description("Sony WH-1000XM5"), price : Price(349.99), image : ImageItem("sony_headphones_image_path")),
    Item(id : UUID(), description : Description("Sony PlayStation 5"), price : Price(499.99), image : ImageItem("ps5_image_path"))
]

let testItems6 = [
    Item(id : UUID(), description : Description("Dell XPS 13"), price : Price(999.99), image : ImageItem("dell_xps_image_path")),
    Item(id : UUID(), description : Description("Logitech MX Master 3"), price : Price(99.99), image : ImageItem("logitech_mouse_image_path"))
]

let testItems7 = [
    Item(id : UUID(), description : Description("Apple MacBook Air M2"), price : Price(1199.99), image : ImageItem("macbook_air_image_path")),
    Item(id : UUID(), description : Description("Apple Magic Mouse"), price : Price(79.99), image : ImageItem("magic_mouse_image_path"))
]

let testItems8 = [
    Item(id : UUID(), description : Description("Microsoft Surface Pro 9"), price : Price(999.99), image : ImageItem("surface_pro_image_path")),
    Item(id : UUID(), description : Description("Surface Pen"), price : Price(99.99), image : ImageItem("surface_pen_image_path"))
]

let testItems9 = [
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

let testItems10 = [
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

let testReceipts = [
    Receipt(
        id: UUID(),
        date: Calendar.current.date(byAdding:.day, value:-9, to:
        Date()) ?? Date(),
        customerName:testCustomerName1,
        items:testItems1
    ),
    Receipt(
        id: UUID(),
        date: Calendar.current.date(byAdding:.day, value:-8, to:
        Date()) ?? Date(),
        customerName:testCustomerName2,
        items:testItems2
     ),
     Receipt(
         id: UUID(),
         date: Calendar.current.date(byAdding:.day, value:-7, to:
         Date()) ?? Date(),
         customerName:testCustomerName3,
         items:testItems3
     ),
     Receipt(
         id: UUID(),
         date: Calendar.current.date(byAdding:.day, value:-6, to:
         Date()) ?? Date(),
         customerName:testCustomerName4,
         items:testItems4
     ),
     Receipt(
         id: UUID(),
         date: Calendar.current.date(byAdding:.day, value:-5, to:
         Date()) ?? Date(),
         customerName:testCustomerName5,
         items:testItems5
     ),
     Receipt(
         id: UUID(),
         date: Calendar.current.date(byAdding:.day, value:-4, to:
         Date()) ?? Date(),
         customerName:testCustomerName6,
         items:testItems6
     ),
     Receipt(
         id: UUID(),
         date: Calendar.current.date(byAdding:.day, value:-3, to:
         Date()) ?? Date(),
         customerName:testCustomerName7,
         items:testItems7
     ),
     Receipt(
         id: UUID(),
         date: Calendar.current.date(byAdding:.day, value:-2, to:
         Date()) ?? Date(),
         customerName:testCustomerName8,
         items:testItems8
     ),
     Receipt(
         id: UUID(),
         date: Calendar.current.date(byAdding:.day, value:-1, to:
         Date()) ?? Date(),
         customerName:testCustomerName9,
         items:testItems9
     ),
     Receipt(
          id: UUID(),
          date: Calendar.current.date(byAdding:.day, value:-0, to:
          Date()) ?? Date(),
          customerName: testCustomerName10,
          items:testItems10
      )
]
