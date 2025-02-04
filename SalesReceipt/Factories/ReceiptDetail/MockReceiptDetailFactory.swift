//
//  MockReceiptDetailFactory.swift
//  SalesReceipt
//
//  Created by Quasar on 05.02.2025.
//

import Foundation

final class MockReceiptDetailFactory: ReceiptDetailFactory {
    func createReceiptDetailViewModel(receipt: Receipt) -> ReceiptDetailViewModel {
        ReceiptDetailViewModel(
            receipt: receipt,
            pdfManager: PDFManager(),
            receiptManager: MockReceiptManager()
        )
    }

    func createReceiptDetailView(receipt: Receipt) -> ReceiptDetailView {
        let viewModel = createReceiptDetailViewModel(receipt: receipt)
        return ReceiptDetailView(viewModel: viewModel)
    }
}
