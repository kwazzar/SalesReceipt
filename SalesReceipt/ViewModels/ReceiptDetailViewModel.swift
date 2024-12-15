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
        let activityVC = UIActivityViewController(activityItems: [pdfUrlReceipt], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}
