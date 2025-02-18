//
//  ReceiptDetailViewModelTests.swift
//  SalesReceiptTests
//
//  Created by Quasar on 17.02.2025.
//

import XCTest
@testable import SalesReceipt

final class ReceiptDetailViewModelTests: XCTestCase {
    var viewModel: ReceiptDetailViewModel!
    var mockPDFManager: MockPDFManager!
    var mockReceiptManager: MockReceiptManager!
    var mockReceipt: Receipt!

    override func setUp() {
        super.setUp()
        mockPDFManager = MockPDFManager()
        mockReceiptManager = MockReceiptManager()
        mockReceipt = Receipt(id: UUID(), date: Date(), customerName: CustomerName("Test Customer"), items: [])
        viewModel = ReceiptDetailViewModel(receipt: mockReceipt, pdfManager: mockPDFManager, receiptManager: mockReceiptManager)
    }

    override func tearDown() {
        viewModel = nil
        mockPDFManager = nil
        mockReceiptManager = nil
        super.tearDown()
    }

    func testCheckPDFExists_WhenPDFExists_ShouldUpdateState() {
        // Arrange
        mockPDFManager.pdfExists = true

        // Act
        let exists = viewModel.checkPDFExists()

        // Assert
        XCTAssertTrue(exists)
        XCTAssertNotNil(viewModel.pdfUrlReceipt)
        XCTAssertTrue(viewModel.isPdfCreated)
        XCTAssertTrue(viewModel.isShareButtonVisible)
    }

    func testGeneratePDF_WhenSuccessful_ShouldUpdateState() {
        // Arrange
        mockPDFManager.shouldGeneratePDF = true
        mockReceiptManager.storedReceipts.append(mockReceipt) // Add the mock receipt to the manager

        // Act
        viewModel.generatePDF()

        // Assert
        XCTAssertNotNil(viewModel.pdfUrlReceipt)
        XCTAssertTrue(viewModel.isPdfCreated)
        XCTAssertTrue(viewModel.isShareButtonVisible)
    }

    func testRetryLastAction_WhenLastActionIsGeneratePDF_ShouldCallGeneratePDF() {
        // Arrange
        viewModel.lastAction = .generatePDF
        mockReceiptManager.storedReceipts.append(mockReceipt) // Ensure the receipt is present

        // Act
        viewModel.retryLastAction()

        // Assert
        XCTAssertTrue(mockPDFManager.generatePDFCalled)
    }
}
