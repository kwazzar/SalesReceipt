//
//  SalesReceiptApp.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import SwiftUI

@main
struct SalesReceiptApp: App {
    private let salesFactory: SalesFactory

    init() {
            self.salesFactory = DefaultSalesFactory()
        }


    var body: some Scene {
        WindowGroup {
            salesFactory.createSalesView()
        }
    }
}
