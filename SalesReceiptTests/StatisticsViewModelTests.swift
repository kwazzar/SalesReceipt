//
//  StatisticsViewModelTests.swift
//  SalesReceiptTests
//
//  Created by Quasar on 15.02.2025.
//

import XCTest
@testable import SalesReceipt

final class StatisticsViewModelTests: XCTestCase {
    var viewModel: StatisticsViewModel!
    var mockStatisticsService: MockStatisticsService!
    
    override func setUp() {
        super.setUp()
        mockStatisticsService = MockStatisticsService()
        viewModel = StatisticsViewModel(statisticsService: mockStatisticsService, receipts: testReceipts)
    }
    
    override func tearDown() {
        viewModel = nil
        mockStatisticsService = nil
        super.tearDown()
    }
    
    func testRefreshStatisticsUpdatesTotalSalesStats() async {
        let expectedTotalStats = TotalStats(total: 1000, itemsSold: 10, averageCheck: 100)
        mockStatisticsService.totalStatsToReturn = expectedTotalStats
        
        viewModel.refreshStatistics()
        
        await waitForStatisticsUpdate()
        
        XCTAssertEqual(viewModel.totalSalesStats?.total, expectedTotalStats.total)
        XCTAssertEqual(viewModel.totalSalesStats?.itemsSold, expectedTotalStats.itemsSold)
        XCTAssertEqual(viewModel.totalSalesStats?.averageCheck.amount, expectedTotalStats.averageCheck.amount)
    }
    
    func testRefreshStatisticsUpdatesDailySalesStats() async {
        let expectedDailySales = [DailySales(date: Date(), totalAmount: 500, itemCount: 5)]
        mockStatisticsService.dailySalesToReturn = expectedDailySales
        
        viewModel.refreshStatistics()
        
        await waitForStatisticsUpdate()
        
        XCTAssertEqual(viewModel.dailySalesStats.count, expectedDailySales.count, "Daily sales count should match expected")
        if let firstDailySale = viewModel.dailySalesStats.first,
           let expectedFirstSale = expectedDailySales.first {
            XCTAssertEqual(firstDailySale.totalAmount, expectedFirstSale.totalAmount, "Daily sales amount should match expected")
        } else {
            XCTFail("Daily sales or expected daily sales is empty when it shouldn't be")
        }
    }
    
    func testRefreshStatisticsUpdatesTopItemSales() async {
        let expectedTopItems = [TopItemStat(item: mockItems[0], count: 5)]
        mockStatisticsService.topItemSalesToReturn = expectedTopItems
        
        viewModel.refreshStatistics()
        
        await waitForStatisticsUpdate()
        
        XCTAssertEqual(viewModel.topItemSales.count, expectedTopItems.count, "Top items count should match expected")
        if let firstTopItem = viewModel.topItemSales.first,
           let expectedFirstItem = expectedTopItems.first {
            XCTAssertEqual(firstTopItem.item.description.value, expectedFirstItem.item.description.value, "Top item description should match expected")
        } else {
            XCTFail("Top items or expected top items is empty when it shouldn't be")
        }
    }
    
    func testSearchTextUpdatesStatistics() async {
        viewModel.searchText = "Test Item"
        
        await waitForStatisticsUpdate()
        
        XCTAssertTrue(mockStatisticsService.isFetchCalled)
    }
    
    func testReceiptsUpdatesStatistics() async {
        let newReceipts = [Receipt(id: UUID(), date: Date(), customerName: CustomerName("Test Customer"), items: [], pdfPath: nil)]
        
        viewModel.receipts = newReceipts
        
        await waitForStatisticsUpdate()
        
        XCTAssertTrue(mockStatisticsService.isFetchCalled)
    }
    
    private func waitForStatisticsUpdate() async {
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
    }
}
