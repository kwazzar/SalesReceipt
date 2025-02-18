//
//  DailySalesViewModelTests.swift
//  SalesReceiptTests
//
//  Created by Quasar on 18.02.2025.
//

import XCTest
@testable import SalesReceipt

final class DailySalesViewModelTests: XCTestCase {
    var viewModel: DailySalesViewModel!
    var mockReceiptManager: MockReceiptManager!
    var mockStatisticsService: MockStatisticsService!

    override func setUp() {
        super.setUp()
        mockReceiptManager = MockReceiptManager()
        mockStatisticsService = MockStatisticsService()
        viewModel = DailySalesViewModel(
            receiptManager: mockReceiptManager,
            statisticsService: mockStatisticsService
        )
    }

    override func tearDown() {
        viewModel = nil
        mockReceiptManager = nil
        mockStatisticsService = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.uiState.showDeletePopup, false)
        XCTAssertEqual(viewModel.uiState.areFiltersApplied, false)
        XCTAssertEqual(viewModel.uiState.currentState, .closed)
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertNil(viewModel.selectedReceipt)
    }

    func testClearAllReceipts() {
        // Given
        let receipt = Receipt(id: UUID(), date: Date(), customerName: CustomerName("Test"), items: [], pdfPath: nil)
        mockReceiptManager.receiptsToReturn = [receipt]

        // When
        viewModel.clearAllReceipts()

        // Then
        XCTAssertTrue(mockReceiptManager.clearAllReceiptsCalled)
        XCTAssertEqual(viewModel.visibleReceipts.count, 0)
    }

    func testDeleteReceipt() {
        // Given
        let receipt = Receipt(id: UUID(), date: Date(), customerName: CustomerName("Test"), items: [], pdfPath: nil)
        mockReceiptManager.receiptsToReturn = [receipt]

        // When
        viewModel.deleteReceipt(receipt)

        // Then
        XCTAssertTrue(mockReceiptManager.deleteReceiptCalled)
        XCTAssertEqual(mockReceiptManager.lastDeletedReceipt?.id, receipt.id)
    }

    func testToggleFilters() {
        // When
        viewModel.toggleFilters()

        // Then
        XCTAssertTrue(viewModel.uiState.areFiltersApplied)

        // When toggle back
        viewModel.toggleFilters()

        // Then
        XCTAssertFalse(viewModel.uiState.areFiltersApplied)
    }

    func testHandleFiltersDisappear() {
        // Given
        viewModel.uiState.currentState = .withFilters

        // When
        viewModel.handleFiltersDisappear()

        // Then
        XCTAssertEqual(viewModel.uiState.currentState, .expanded)
    }

    func testCloseStatistics() {
        // Given
        viewModel.uiState.currentState = .expanded

        // When
        viewModel.closeStatistics()

        // Then
        XCTAssertEqual(viewModel.uiState.currentState, .closed)
    }

    func testUpdateVisibleReceiptsWithFilters() {
        // Given
        let receipt = Receipt(id: UUID(), date: Date(), customerName: CustomerName("Test"), items: [], pdfPath: nil)
        mockReceiptManager.receiptsToReturn = [receipt]

        // When
        viewModel.searchText = "Test"

        // Then
        XCTAssertTrue(mockReceiptManager.filterCalled)
    }
}
