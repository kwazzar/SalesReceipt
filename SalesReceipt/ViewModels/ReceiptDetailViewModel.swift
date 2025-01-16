//
//  ReceiptDetailViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 30.11.2024.
//

import Foundation
import SwiftUI

final class ReceiptDetailViewModel: ObservableObject {
    @Published var pdfUrlReceipt: URL?
    @Published var isPdfCreated = false
    @Published var isShareButtonVisible = false
    @Published var errorMessage: String?
    
    let receipt: Receipt
    private let pdfManager: PDFAPI
    private let receiptManager: ReceiptDatabaseAPI
    
    init(
        receipt: Receipt,
        pdfManager: PDFAPI,
        receiptManager: ReceiptDatabaseAPI
    ) {
        self.receipt = receipt
        self.pdfManager = pdfManager
        self.receiptManager = receiptManager
    }
    
    func checkPDFExists() -> Bool {
        do {
            let pdfPath = try pdfManager.checkPDFExists(for: receipt)
            pdfUrlReceipt = pdfPath
            isPdfCreated = true
            return true
        } catch {
            errorMessage = error.localizedDescription
            isPdfCreated = false
            return false
        }
    }
    
    func generatePDF() {
        do {
            guard let pdfPath = try pdfManager.generatePDF(for: receipt) else {
                throw PDFError.pdfGenerationFailed
            }
            
            try receiptManager.updatePDFPath(for: receipt.id, path: pdfPath.path)
            pdfUrlReceipt = pdfPath
            isPdfCreated = true
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            isPdfCreated = false
        }
    }

    func sharePDF() {
        guard let pdfUrlReceipt = pdfUrlReceipt else { return }

        do {
            let pdfData = try Data(contentsOf: pdfUrlReceipt)
            let temporaryDir = FileManager.default.temporaryDirectory
            let temporaryFileURL = temporaryDir.appendingPathComponent(UUID().uuidString + ".pdf")
            try pdfData.write(to: temporaryFileURL)

            try (temporaryFileURL as NSURL).setResourceValue(true, forKey: .isReadableKey)

            let activityVC = UIActivityViewController(
                activityItems: [pdfData],
                applicationActivities: nil
            )

            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {

                    if let popoverController = activityVC.popoverPresentationController {
                        popoverController.sourceView = window
                        popoverController.sourceRect = CGRect(x: window.bounds.midX,
                                                              y: window.bounds.midY,
                                                              width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }

                    if let topController = window.rootViewController?.topMostViewController() {
                        topController.present(activityVC, animated: true) {
                            try? FileManager.default.removeItem(at: temporaryFileURL)
                        }
                    }
                }
            }
        } catch {
            errorMessage = "Не вдалося поділитися PDF: \(error.localizedDescription)"
        }
    }
}
