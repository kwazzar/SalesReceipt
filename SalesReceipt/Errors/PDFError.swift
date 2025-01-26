//
//  PDFError.swift
//  SalesReceipt
//
//  Created by Quasar on 06.12.2024.
//

import Foundation

enum PDFError: Error, LocalizedError {
    case missingURL
    case directoryCreationFailed
    case pdfGenerationFailed
    case pdfSaveFailed
    case pdfNotFound
    case sharingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .missingURL:
            return "The URL is missing."
        case .directoryCreationFailed:
            return "Failed to create directory for PDF storage."
        case .pdfGenerationFailed:
            return "PDF generation failed."
        case .pdfSaveFailed:
            return "Unable to save PDF to file system."
        case .pdfNotFound:
            return "PDF file does not exist."
        case .sharingFailed(_):
            return "sharing Failed"
        }
    }
}
