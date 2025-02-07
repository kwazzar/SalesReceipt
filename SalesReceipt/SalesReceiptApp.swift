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
        _coordinator = StateObject(wrappedValue: MainCoordinator(container: MainContainer.shared))
    }
    
    var body: some Scene {
        WindowGroup {
            coordinator.view()
        }
    }
}
