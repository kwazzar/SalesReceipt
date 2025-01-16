//
//  PDFAPI.swift
//  SalesReceipt
//
//  Created by Quasar on 15.01.2025.
//

import Foundation
import UIKit

protocol PDFAPI {
    func generatePDF(for receipt: Receipt) throws -> URL?
    func checkPDFExists(for receipt: Receipt) throws -> URL
    func savePDFToFileSystem(receipt: Receipt) throws -> URL
}

extension PDFAPI {
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let date = "Date: \(dateFormatter.string(from: receipt.date))"
        title.draw(at: CGPoint(x: 20, y: 20), withAttributes: titleAttributes)
        date.draw(at: CGPoint(x: 20, y: 50), withAttributes: contentAttributes)

        // Draw receipt details
        var yPosition: CGFloat = 90
        for item in receipt.items {
            let itemText = "\(item.quantity)x  \(item.description.value) - \(item.price.value) $"
            itemText.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: contentAttributes)
            yPosition += 30
        }
        // Draw total
        let totalText = "Total: \(receipt.total) $"
        totalText.draw(at: CGPoint(x: 20, y: yPosition + 20), withAttributes: titleAttributes)
    }
}
