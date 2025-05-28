//
//  SalesReceiptApp.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import SwiftUI

@main
struct SalesReceiptApp: App {
    @StateObject private var coordinator: MainCoordinator

    init() {
        let container = MainContainer.shared

        _coordinator = StateObject(wrappedValue: MainCoordinator(
            makeSalesView: { container.createSalesView() },
            makeDailySalesView: { container.createDailySalesView() },
            makeReceiptDetailView: { receipt in
                container.createReceiptDetailView(receipt: receipt)
            }
        ))
    }

    var body: some Scene {
        WindowGroup {
            coordinator.view()
        }
    }
}
