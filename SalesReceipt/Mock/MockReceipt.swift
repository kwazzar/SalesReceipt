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
