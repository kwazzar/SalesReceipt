//
//  PDFAPI.swift
//  SalesReceipt
//
//  Created by Quasar on 15.01.2025.
//

import Foundation

protocol PDFAPI {
    func generatePDF(for receipt: Receipt) throws -> URL?
    func checkPDFExists(for receipt: Receipt) throws -> URL
    func savePDFToFileSystem(receipt: Receipt) throws -> URL
}
