//
//  DefaultSalesFactory.swift
//  SalesReceipt
//
//  Created by Quasar on 29.01.2025.
//

import Foundation

final class DefaultSalesFactory: SalesFactory {
    private let database: SalesDatabaseProtocol

    init(database: SalesDatabaseProtocol = SalesDatabase.shared) {
        self.database = database
    }

    func createSalesViewModel() -> SalesViewModel {
        let receiptManager = ReceiptManager(database: database)
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
