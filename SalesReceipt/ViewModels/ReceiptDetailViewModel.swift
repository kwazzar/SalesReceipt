//
//  ReceiptDetailViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 30.11.2024.
//

import SwiftUI

final class ReceiptDetailViewModel: ObservableObject {
    @Published var pdfUrlReceipt: URL?
    @Published var isPdfCreated = false
    @Published var isShareButtonVisible = false
    @Published var errorMessage: String?
    @Published var showErrorAlert = false

    let receipt: Receipt
    private let pdfManager: PDFAPI
    private let receiptManager: ReceiptDatabaseAPI
    var lastAction: PDFAction?

    init(receipt: Receipt, pdfManager: PDFAPI, receiptManager: ReceiptDatabaseAPI) {
        self.receipt = receipt
        self.pdfManager = pdfManager
        self.receiptManager = receiptManager
        self.showErrorAlert = false
    }

    func checkPDFExists() -> Bool {
        do {
            let pdfPath = try pdfManager.checkPDFExists(for: receipt)
            updatePDFState(pdfPath: pdfPath)
            return true
        } catch {
            if !(error is PDFError) {
                 handleError(error)
             }
            return false
        }
    }

    func generatePDF() {
        lastAction = .generatePDF
        do {
            guard let pdfPath = try pdfManager.generatePDF(for: receipt) else {
                throw PDFError.pdfGenerationFailed
            }

            try receiptManager.updatePDFPath(for: receipt.id, path: pdfPath.path)
            updatePDFState(pdfPath: pdfPath)
        } catch {
            handleError(error)
        }
    }

    func sharePDF() {
        lastAction = .sharePDF
        guard let pdfUrlReceipt = pdfUrlReceipt else {
            handleError(PDFError.pdfNotFound)
            return
        }

        do {
            let pdfData = try preparePDFForSharing(from: pdfUrlReceipt)
            presentShareSheet(with: pdfData)
        } catch {
            handleError(PDFError.sharingFailed(error))
        }
    }

    func retryLastAction() {
        switch lastAction {
        case .generatePDF:
            generatePDF()
        case .sharePDF:
            sharePDF()
        case .none:
            break
        }
    }
}

//MARK: - PDFAction
enum PDFAction {
    case generatePDF
    case sharePDF
}

//MARK: - Extension
extension ReceiptDetailViewModel {
    private func updatePDFState(pdfPath: URL) {
        pdfUrlReceipt = pdfPath
        isPdfCreated = true
        isShareButtonVisible = true
        errorMessage = nil
    }

    private func handleError(_ error: Error) {
        print("Error occurred: \(error.localizedDescription)")
        errorMessage = error.localizedDescription
        showErrorAlert = true
    }

    private func preparePDFForSharing(from url: URL) throws -> Data {
        let pdfData = try Data(contentsOf: url)
        let temporaryFileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".pdf")
        try pdfData.write(to: temporaryFileURL)
        try (temporaryFileURL as NSURL).setResourceValue(true, forKey: .isReadableKey)
        return pdfData
    }

//MARK: - ShareSheet
    private func presentShareSheet(with pdfData: Data) {
        let activityVC = UIActivityViewController(
            activityItems: [pdfData],
            applicationActivities: nil
        )

        activityVC.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .markupAsPDF,
            .openInIBooks,
            .saveToCameraRoll,
            .print
        ]
        
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let topController = window.rootViewController?.topMostViewController() else {
                return
            }
            
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = window
                popoverController.sourceRect = window.bounds.centered
                popoverController.permittedArrowDirections = []
            }
            topController.present(activityVC, animated: true)
        }
    }
}
