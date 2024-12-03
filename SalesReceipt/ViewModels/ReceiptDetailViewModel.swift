//
//  ReceiptDetailViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 30.11.2024.
//

import Foundation
import SwiftUI

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
    let database = SalesDatabase.shared
    let receipt: Receipt
    let pdfGenerator: PDFGeneratorApi
    @Published var pdfUrlReceipt: PdfUrlReceipt?
    @Published var isPdfCreated = false

    init(receipt: Receipt, pdfGenerator: PDFGeneratorApi) {
        self.pdfGenerator = pdfGenerator
        self.receipt = receipt
        print("ViewModel Init: Receipt ID - \(receipt.id)")
    }

    func checkPDFExists() -> Bool {
        guard let existingReceipt = database.getAllReceipts().first(where: { $0.id == receipt.id }) else {
            print("❌ checkPDFExists: No receipt found with ID \(receipt.id)")
            return false
        }

        // Безпосередня перевірка файлу
        let pdfPath = "\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)/Receipts/Receipt_\(receipt.id).pdf"

        let pdfPathExists = FileManager.default.fileExists(atPath: pdfPath)
        print("✅ checkPDFExists: PDF Path Exists - \(pdfPathExists)")
        print("🔍 PDF Path: \(pdfPath)")

        if pdfPathExists {
            do {
                pdfUrlReceipt = try PdfUrlReceipt(URL(fileURLWithPath: pdfPath))
                print("🔍 PDF URL Set: \(pdfPath)")
                isPdfCreated = true
            } catch {
                print("❌ Error setting PDF URL: \(error)")
                isPdfCreated = false
            }
        }
        return pdfPathExists
    }

    func generatePDF() {
        print("🖨️ Starting PDF Generation")
        print("📋 Receipt ID: \(receipt.id)")

        do {
            // Перевірка на наявність PDF в базі даних
            if let existingReceipt = database.getAllReceipts().first(where: { $0.id == receipt.id }),
               let existingPdfPath = existingReceipt.pdfPath?.value {
                print("📄 Existing PDF found in database: \(existingPdfPath)")

                // Додаткова перевірка файлу
                if FileManager.default.fileExists(atPath: existingPdfPath) {
                    pdfUrlReceipt = try PdfUrlReceipt(URL(fileURLWithPath: existingPdfPath))
                    isPdfCreated = true
                    print("✅ PDF file confirmed: \(existingPdfPath)")
                    return
                } else {
                    print("❌ PDF file from database does not exist")
                }
            }

            guard let generatedURL = pdfGenerator.savePDFToFileSystem(receipt: receipt) else {
                print("❌ PDF Generation Failed: URL is nil")
                throw PdfError.notCreated
            }

            print("✅ PDF Generated: \(generatedURL.path)")
            try database.updatePdfPath(for: receipt.id, pdfPath: generatedURL.path)

            pdfUrlReceipt = try PdfUrlReceipt(generatedURL)
            isPdfCreated = true

            print("🎉 PDF URL Set and Created Successfully")
            print("📍 Final PDF Path: \(generatedURL.path)")
        } catch {
            print("❌ Error generating PDF: \(error.localizedDescription)")
            isPdfCreated = false
            pdfUrlReceipt = nil
        }
    }

    func sharePDF(pdfUrl: PdfUrlReceipt) {
        let activityVC = UIActivityViewController(activityItems: [pdfUrl.value], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}
