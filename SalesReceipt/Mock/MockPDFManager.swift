//
//  MockPDFManager.swift
//  SalesReceipt
//
//  Created by Quasar on 17.02.2025.
//

import Foundation

final class MockPDFManager: PDFAPI {
    var pdfExists = false
    var shouldGeneratePDF = false
    var generatePDFCalled = false

    func checkPDFExists(for receipt: Receipt) throws -> URL {
        if pdfExists {
            return URL(string: "mockPDFPath")!
        } else {
            throw PDFError.pdfNotFound
        }
    }

    func generatePDF(for receipt: Receipt) throws -> URL? {
        generatePDFCalled = true
        if shouldGeneratePDF {
            return URL(string: "mockPDFPath") // Return a valid URL
        } else {
            throw PDFError.pdfGenerationFailed
        }
    }

    func savePDFToFileSystem(receipt: Receipt) throws -> URL {
        return URL(string: "mockPDFPath")!
    }
}
