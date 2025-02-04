//
//  DefaultReceiptDetailFactory.swift
//  SalesReceipt
//
//  Created by Quasar on 05.02.2025.
//

import Foundation

final class DefaultReceiptDetailFactory: ReceiptDetailFactory {
    private let database: SalesDatabaseProtocol

    init(database: SalesDatabaseProtocol = SalesDatabase.shared) {
        self.database = database
    }

    func createReceiptDetailViewModel(receipt: Receipt) -> ReceiptDetailViewModel {
        ReceiptDetailViewModel(
            receipt: receipt,
            pdfManager: PDFManager(),
            receiptManager: ReceiptManager(database: database)
        )
    }

    func createReceiptDetailView(receipt: Receipt) -> ReceiptDetailView {
        let viewModel = createReceiptDetailViewModel(receipt: receipt)
        return ReceiptDetailView(viewModel: viewModel)
    }
}
