//
//  ReceiptDetailViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 30.11.2024.
//

import Foundation
import SwiftUI

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

    func generatePDF() {
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


//final class ReceiptDetailViewModel: ObservableObject {
//    @Published var pdfUrlReceipt: PdfUrlReceipt?
//    @Published var isPdfCreated = false
//    @Published var isShareButtonVisible = false
//
//    let database: SalesDatabaseProtocol
//    let receipt: Receipt
//    let pdfGenerator: PDFGeneratorApi
//
//    init(receipt: Receipt, database: SalesDatabaseProtocol, pdfGenerator: PDFGeneratorApi) {
//        self.receipt = receipt
//        self.database = database
//        self.pdfGenerator = pdfGenerator
//    }
//
//    func checkPDFExists() -> Bool {
//        guard database.fetchAllReceipts().first(where: { $0.id == receipt.id }) != nil else {
//            print("❌ checkPDFExists: No receipt found with ID \(receipt.id)")
//            return false
//        }
//
//        // Безпосередня перевірка файлу
//        let pdfPath = "\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)/Receipts/Receipt_\(receipt.id).pdf"
//
//        let pdfPathExists = FileManager.default.fileExists(atPath: pdfPath)
//        print("✅ checkPDFExists: PDF Path Exists - \(pdfPathExists)")
//        print("🔍 PDF Path: \(pdfPath)")
//
//        if pdfPathExists {
//            do {
//                pdfUrlReceipt = try PdfUrlReceipt(URL(fileURLWithPath: pdfPath))
//                print("🔍 PDF URL Set: \(pdfPath)")
//                isPdfCreated = true
//            } catch {
//                print("❌ Error setting PDF URL: \(error)")
//                isPdfCreated = false
//            }
//        }
//        return pdfPathExists
//    }
//
//    func generatePDF() {
//        print("🖨️ Starting PDF Generation")
//        print("📋 Receipt ID: \(receipt.id)")
//
//        do {
//            // Перевірка на наявність PDF в базі даних
//            if let existingReceipt = database.fetchAllReceipts().first(where: { $0.id == receipt.id }),
//               let existingPdfPath = existingReceipt.pdfPath?.value {
//                print("📄 Existing PDF found in database: \(existingPdfPath)")
//
//                // Додаткова перевірка файлу
//                if FileManager.default.fileExists(atPath: existingPdfPath) {
//                    pdfUrlReceipt = try PdfUrlReceipt(URL(fileURLWithPath: existingPdfPath))
//                    isPdfCreated = true
//                    print("✅ PDF file confirmed: \(existingPdfPath)")
//                    return
//                } else {
//                    print("❌ PDF file from database does not exist")
//                }
//            }
//
//            guard let generatedURL = pdfGenerator.savePDFToFileSystem(receipt: receipt) else {
//                print("❌ PDF Generation Failed: URL is nil")
//                throw PdfError.notCreated
//            }
//
//            print("✅ PDF Generated: \(generatedURL.path)")
//            try database.updatePdfPath(for: receipt.id, pdfPath: generatedURL.path)
//
//            pdfUrlReceipt = try PdfUrlReceipt(generatedURL)
//            isPdfCreated = true
//
//            print("🎉 PDF URL Set and Created Successfully")
//            print("📍 Final PDF Path: \(generatedURL.path)")
//        } catch {
//            print("❌ Error generating PDF: \(error.localizedDescription)")
//            isPdfCreated = false
//            pdfUrlReceipt = nil
//        }
//    }
//
//    func sharePDF(pdfUrl: PdfUrlReceipt) {
//        let activityVC = UIActivityViewController(activityItems: [pdfUrl.value], applicationActivities: nil)
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
//        }
//    }
//}

//MARK: - PdfError
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
