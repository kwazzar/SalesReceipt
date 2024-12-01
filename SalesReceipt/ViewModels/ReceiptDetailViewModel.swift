//
//  ReceiptDetailViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 30.11.2024.
//

import Foundation
import SwiftUI

enum PdfUrlError: Error, LocalizedError {
    case missingURL

    var errorDescription: String? {
        switch self {
        case .missingURL:
            return "The URL is missing."
        }
    }
}

struct PdfUrlReceipt: ItemProtocol {
    var value: URL

    init(_ value: URL? = nil) throws {
        guard let value = value else {
            throw PdfUrlError.missingURL
        }
        self.value = value
    }
}

final class ReceiptDetailViewModel: ObservableObject {
    let receipt: Receipt
    let pdfGenerator: PDFGeneratorApi
    @Published var pdfUrlReceipt: PdfUrlReceipt?
    @Published var isPdfCreated = false  // Состояние для отслеживания появления кнопки

    init(receipt: Receipt, pdfGenerator: PDFGeneratorApi) {
        self.pdfGenerator = pdfGenerator
        self.receipt = receipt
    }

    func generatePDF() {
        do {
            let generatedURL = pdfGenerator.generatePDF(receipt: receipt)
            pdfUrlReceipt = try PdfUrlReceipt(generatedURL)
        } catch {
            print("Error generating PDF: \(error.localizedDescription)")
        }
    }

    func sharePDF(pdfUrl: PdfUrlReceipt) {
        let activityVC = UIActivityViewController(activityItems: [pdfUrl.value], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}
