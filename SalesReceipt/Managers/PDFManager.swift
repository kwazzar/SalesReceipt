//
//  PDFManager.swift
//  SalesReceipt
//
//  Created by Quasar on 04.12.2024.
//

import Foundation
import UIKit

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
        
        let receiptsDirectory = documentDirectory.appendingPathComponent("Receipts")
        try FileManager.default.createDirectory(at: receiptsDirectory, withIntermediateDirectories: true)
        
        let outputURL = documentDirectory.appendingPathComponent("Receipts/Receipt_\(receipt.id).pdf")
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        
        do {
            try renderer.writePDF(to: outputURL) { context in
                context.beginPage()
                drawReceiptContent(receipt, in: context.cgContext)
            }
            try (outputURL as NSURL).setResourceValue(true, forKey: .isReadableKey)
            
            return outputURL
        } catch {
            throw PDFError.pdfSaveFailed
        }
    }
}
