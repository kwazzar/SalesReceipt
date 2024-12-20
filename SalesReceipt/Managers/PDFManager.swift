//
//  PDFManager.swift
//  SalesReceipt
//
//  Created by Quasar on 04.12.2024.
//

import Foundation
import UIKit

protocol PDFAPI {
    func generatePDF(for receipt: Receipt) throws -> URL?
    func checkPDFExists(for receipt: Receipt) throws -> URL
    func savePDFToFileSystem(receipt: Receipt) throws -> URL
}

final class PDFManager: PDFAPI {
    func generatePDF(for receipt: Receipt) throws -> URL? {
        do {
            let pdfPath = try savePDFToFileSystem(receipt: receipt)
            return pdfPath
        } catch {
            throw PDFError.pdfGenerationFailed
        }
    }
    
    func checkPDFExists(for receipt: Receipt) throws -> URL {
        let pdfPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent("Receipts/Receipt_\(receipt.id).pdf")
        
        guard let pdfPath = pdfPath,
              FileManager.default.fileExists(atPath: pdfPath.path) else {
            throw PDFError.pdfNotFound
        }
        return pdfPath
    }
    
    func savePDFToFileSystem(receipt: Receipt) throws -> URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw PDFError.missingURL
        }
        
        let outputURL = documentDirectory.appendingPathComponent("Receipts/Receipt_\(receipt.id).pdf")
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        
        do {
            try FileManager.default.createDirectory(
                at: outputURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            
            try renderer.writePDF(to: outputURL) { context in
                context.beginPage()
                drawReceiptContent(receipt, in: context.cgContext)
            }
            
            return outputURL
        } catch {
            throw PDFError.pdfSaveFailed
        }
    }
    
    private func drawReceiptContent(_ receipt: Receipt, in context: CGContext) {
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
