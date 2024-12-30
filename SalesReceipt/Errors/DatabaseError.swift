//
//  DatabaseError.swift
//  SalesReceipt
//
//  Created by Quasar on 06.12.2024.
//

import Foundation

enum DatabaseError: Error, LocalizedError {
    case fetchReceiptsFailed(underlyingError: Error)
    case clearReceiptsFailed(underlyingError: Error)
    case updatePDFPathFailed(reason: UpdatePDFPathFailureReason)
    case deleteReceiptFailed(reason: DeleteReceiptFailureReason)

    enum UpdatePDFPathFailureReason {
        case receiptNotFound
        case contextSaveFailed(underlyingError: Error?)
    }

    enum DeleteReceiptFailureReason {
        case receiptNotFound
        case deletionFailed(Error)
    }

    var errorDescription: String? {
        switch self {
        case .fetchReceiptsFailed(let error):
            return "fetchReceiptsFailed: \(error.localizedDescription)"
        case .clearReceiptsFailed(let error):
            return "clearReceiptsFailed: \(error.localizedDescription)"
        case .updatePDFPathFailed(let reason):
            switch reason {
            case .receiptNotFound:
                return "receiptNotFound"
            case .contextSaveFailed(let error):
                return "contextSaveFailed: \(error?.localizedDescription ?? "unknown error")"
            }
        case .deleteReceiptFailed(reason: let reason):
            switch reason {
            case .receiptNotFound:
                return "receiptNotFound"
            case .deletionFailed(let error):
                return "deletionFailed \(error.localizedDescription)"
            }
        }
    }
}
