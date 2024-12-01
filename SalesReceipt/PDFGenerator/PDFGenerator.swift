//
//  PDFGenerator.swift
//  SalesReceipt
//
//  Created by Quasar on 13.11.2024.
//

import SwiftUI
import PDFKit

#warning("Добавить генерацию PDF-чеков")
// Step 1: Define a struct for the PDF generator
protocol PDFGeneratorApi {
    func generatePDF(receipt: Receipt) -> URL?
    func drawReceiptContent(_ receipt: Receipt, in context: CGContext)
}

struct PDFGenerator: PDFGeneratorApi {

    func generatePDF(receipt: Receipt) -> URL? {
        // Step 2: Set up file path for saving the PDF
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to locate document directory.")
            return nil
        }
        let outputURL = documentDirectory.appendingPathComponent("Receipt_\(receipt.id).pdf")

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))

        // Step 3: Start PDF rendering
        do {
            try renderer.writePDF(to: outputURL) { context in
                context.beginPage()

                // Step 4: Draw PDF content
                drawReceiptContent(receipt, in: context.cgContext)
            }
            return outputURL
        } catch {
            print("Failed to generate PDF: \(error)")
            return nil
        }
    }

    func drawReceiptContent(_ receipt: Receipt, in context: CGContext) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]
        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.darkGray
        ]

        // Draw title
        let title = "Sales Receipt"
        title.draw(at: CGPoint(x: 20, y: 20), withAttributes: titleAttributes)

        // Draw receipt details
        var yPosition: CGFloat = 60
        for item in receipt.items {
            let itemText = "\(item.description) - \(item.price.value) $"
            itemText.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: contentAttributes)
            yPosition += 30
        }

        // Draw total
        let totalText = "Total: \(receipt.total) $"
        totalText.draw(at: CGPoint(x: 20, y: yPosition + 20), withAttributes: titleAttributes)
    }
}
