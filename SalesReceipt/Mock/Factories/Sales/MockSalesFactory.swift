//
//  MockSalesFactory.swift
//  SalesReceipt
//
//  Created by Quasar on 03.02.2025.
//

import Foundation

final class MockSalesFactory: SalesFactory {
    func createSalesViewModel() -> SalesViewModel {
        let mockDatabase = MockSalesDatabase()
        let receiptManager = ReceiptManager(database: mockDatabase)
        let itemManager = ItemManager()
        return SalesViewModel(
            receiptManager: receiptManager,
            itemManager: itemManager
        )
    }

    func createSalesView() -> SalesView {
        let viewModel = createSalesViewModel()
        return SalesView(viewModel: viewModel)
    }
}
