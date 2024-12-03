//
//  PDFGenerator.swift
//  SalesReceipt
//
//  Created by Quasar on 13.11.2024.
//

import SwiftUI
import PDFKit

protocol PDFGeneratorApi {
    func drawReceiptContent(_ receipt: Receipt, in context: CGContext)
    func savePDFToFileSystem(receipt: Receipt) -> URL?
}

struct PDFGenerator: PDFGeneratorApi {

    func savePDFToFileSystem(receipt: Receipt) -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to locate document directory.")
            return nil
        }

        let outputURL = documentDirectory.appendingPathComponent("Receipts/Receipt_\(receipt.id).pdf")
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))

        do {
            try FileManager.default.createDirectory(at: outputURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            try renderer.writePDF(to: outputURL) { context in
                context.beginPage()
                drawReceiptContent(receipt, in: context.cgContext)
            }
            return outputURL
        } catch {
            print("Failed to save PDF: \(error)")
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
