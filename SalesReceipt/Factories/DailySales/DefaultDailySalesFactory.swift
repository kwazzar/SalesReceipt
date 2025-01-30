//
//  DefaultDailySalesFactory.swift
//  SalesReceipt
//
//  Created by Quasar on 29.01.2025.
//

import Foundation

final class DefaultDailySalesFactory: DailySalesFactory {
    private let database: SalesDatabaseProtocol

    init(database: SalesDatabaseProtocol = SalesDatabase.shared) {
        self.database = database
    }

    func createDailySalesViewModel() -> DailySalesViewModel {
        let receiptManager = ReceiptManager(database: database)
        let statisticsManager = StatisticsManager()
        return DailySalesViewModel(
            receiptManager: receiptManager,
            statisticsService: statisticsManager
        )
    }

    func createDailySalesView() -> DailySalesView {
        let viewModel = createDailySalesViewModel()
        return DailySalesView(viewModel: viewModel)
    }
}
