//
//  DefaultCoordinatorFactory.swift
//  SalesReceipt
//
//  Created by Quasar on 05.02.2025.
//

import Foundation

final class MainContainer: CoordinatorContainer {
    static let shared = MainContainer()

    private let database: SalesDatabaseProtocol
    private lazy var receiptManager = ReceiptManager(database: database)
    private lazy var itemManager = ItemManager()
    private lazy var statisticsManager = StatisticsManager()

    init(database: SalesDatabaseProtocol = SalesDatabase.shared) {
        self.database = database
    }

    func createSalesView() -> SalesView {
        let viewModel = SalesViewModel(
            receiptManager: receiptManager,
            itemManager: itemManager
        )
        return SalesView(viewModel: viewModel)
    }

    func createDailySalesView() -> DailySalesView {
        let viewModel = DailySalesViewModel(
            receiptManager: receiptManager,
            statisticsService: statisticsManager
        )
        return DailySalesView(viewModel: viewModel)
    }

    func createReceiptDetailView(receipt: Receipt) -> ReceiptDetailView {
        let pdfManager = PDFManager()

        let viewModel = ReceiptDetailViewModel(
            receipt: receipt,
            pdfManager: pdfManager,
            receiptManager: receiptManager
        )
        return ReceiptDetailView(viewModel: viewModel)
    }
}
