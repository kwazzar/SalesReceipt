//
//  MockDailySalesFactory.swift
//  SalesReceipt
//
//  Created by Quasar on 03.02.2025.
//

import Foundation

final class MockDailySalesFactory: DailySalesFactory {
    func createDailySalesViewModel() -> DailySalesViewModel {
//        let mockDatabase = MockSalesDatabase()
        let receiptManager = MockReceiptManager()
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
