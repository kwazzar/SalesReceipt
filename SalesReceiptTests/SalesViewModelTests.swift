//
//  SalesViewModelTests.swift
//  SalesReceiptTests
//
//  Created by Quasar on 14.02.2025.
//

import XCTest
@testable import SalesReceipt

final class SalesViewModelTests: XCTestCase {
    var viewModel: SalesViewModel!
    var mockReceiptManager: MockReceiptManager!
    var mockItemManager: MockItemManager!

    override func setUp() {
        super.setUp()
        mockReceiptManager = MockReceiptManager()
        mockReceiptManager.storedReceipts.removeAll()
        mockItemManager = MockItemManager()
        viewModel = SalesViewModel(receiptManager: mockReceiptManager, itemManager: mockItemManager)
    }

    override func tearDown() {
        viewModel = nil
        mockReceiptManager = nil
        mockItemManager = nil
        super.tearDown()
    }

    func testAddItemIncreasesTotal() {
        let item = Item(id: UUID(), description: Description("Test Item"), price: Price(10.0), image: ImageItem(""), quantity: 1)
        viewModel.addItem(item)

        XCTAssertEqual(viewModel.total.value, 10.0, "Total should be 10.0 after adding one item priced at 10.0")
    }

    func testDeleteItemDecreasesTotal() {
        let item = Item(id: UUID(), description: Description("Test Item"), price: Price(10.0), image: ImageItem(""), quantity: 1)
        viewModel.addItem(item)
        viewModel.deleteItem(item)

        XCTAssertEqual(viewModel.total.value, 0.0, "Total should be 0.0 after deleting the only item")
    }

    func testClearAllResetsTotal() {
        let item = Item(id: UUID(), description: Description("Test Item"), price: Price(10.0), image: ImageItem(""), quantity: 1)
        viewModel.addItem(item)
        viewModel.clearAll()

        XCTAssertEqual(viewModel.total.value, 0.0, "Total should be 0.0 after clearing all items")
        XCTAssertEqual(viewModel.customerName.value, "Anonymous", "Customer name should be 'Anonymous' after clearing")
    }

    func testFinalizeCheckoutSavesReceipt() {
        let item = Item(id: UUID(), description: Description("Test Item"), price: Price(10.0), image: ImageItem(""), quantity: 1)
        viewModel.addItem(item)
        let customerName = CustomerName("Test Customer")

        let success: Bool = viewModel.finalizeCheckout(with: customerName)

        XCTAssertTrue(success, "Checkout should be successful with items present")
        XCTAssertEqual(mockReceiptManager.storedReceipts.count, 1, "One receipt should be saved")
        XCTAssertEqual(mockReceiptManager.storedReceipts.first?.customerName.value, "Test Customer", "Customer name should match")
    }
}
