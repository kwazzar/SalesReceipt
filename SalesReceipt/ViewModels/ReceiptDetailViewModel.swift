//
//  ReceiptDetailViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 30.11.2024.
//

import Foundation
import SwiftUI

//MARK: - PdfError
#warning("add cases")
enum PdfError: Error, LocalizedError {
    case missingURL
    case notCreated

    var errorDescription: String? {
        switch self {
        case .missingURL:
            return "The URL is missing."
        case .notCreated:
            return "Pdf not created"
        }
    }
}

//MARK: - PdfUrlReceipt
struct PdfUrlReceipt: Hashable {
    var value: URL

    init(_ value: URL? = nil) throws {
        guard let value = value else {
            throw PdfError.missingURL
        }
        self.value = value
    }
}


final class ReceiptDetailViewModel: ObservableObject {
    @Published var pdfUrlReceipt: PdfUrlReceipt?
    @Published var isPdfCreated = false
    @Published var isShareButtonVisible = false

    let receipt: Receipt
    private let pdfManager: PDFAPI
    private let databaseManager: ReceiptDatabaseAPI

    init(
        receipt: Receipt,
        pdfManager: PDFAPI,
        databaseManager: ReceiptDatabaseAPI
    ) {
        self.receipt = receipt
        self.pdfManager = pdfManager
        self.databaseManager = databaseManager
    }

    func checkPDFExists() -> Bool {
        guard let pdfPath = pdfManager.checkPDFExists(for: receipt) else {
            print("❌ PDF does not exist for receipt ID: \(receipt.id)")
            return false
        }

        do {
            pdfUrlReceipt = try PdfUrlReceipt(pdfPath)
            isPdfCreated = true
            return true
        } catch {
            print("❌ Error initializing PdfUrlReceipt: \(error)")
            return false
        }
    }

    func generatePDF()  {
        do {
            guard let pdfPath = pdfManager.generatePDF(for: receipt) else {
                throw PdfError.notCreated
            }

            try databaseManager.updatePDFPath(for: receipt.id, path: pdfPath.path)
            pdfUrlReceipt = try PdfUrlReceipt(pdfPath)
            isPdfCreated = true
        } catch {
            print("❌ Error generating PDF: \(error.localizedDescription)")
            isPdfCreated = false
        }
    }

    func sharePDF() {
        guard let pdfUrlReceipt = pdfUrlReceipt else { return }
        let activityVC = UIActivityViewController(activityItems: [pdfUrlReceipt.value], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}
