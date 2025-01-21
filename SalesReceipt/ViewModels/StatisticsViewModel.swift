//
//  StatisticsViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 19.12.2024.
//

import Foundation
// MARK: - Protocols
protocol StatisticsViewModelInput {
    var receipts: [Receipt] { get set }
    var searchText: String? { get set }
    func calculateStatistics()
}

protocol StatisticsViewModelOutput {
    var totalSalesStats: (total: Double, itemsSold: Int, averageCheck: Double)? { get }
    var dailySalesStats: [SalesStat] { get }
    var topItemSales: [(item: Item, count: Int)] { get }
}

protocol StatisticsViewModelProtocol: StatisticsViewModelInput, StatisticsViewModelOutput, ObservableObject {}

// MARK: - ViewModel
final class StatisticsViewModel: StatisticsViewModelProtocol {
    // MARK: - Published Properties (Output)
    @Published private(set) var totalSalesStats: (total: Double, itemsSold: Int, averageCheck: Double)?
    @Published private(set) var dailySalesStats: [SalesStat] = []
    @Published private(set) var topItemSales: [(item: Item, count: Int)] = []

    // MARK: - Input Properties
    @Published var receipts: [Receipt] {
        didSet { calculateStatistics() }
    }
    @Published var searchText: String? {
        didSet { calculateStatistics() }
    }

    // MARK: - Dependencies
    private let statisticsService: StatisticsAPI
    private let topSalesLimit: Int

    // MARK: - Initialization
    init(
        statisticsService: StatisticsAPI,
        receipts: [Receipt],
        searchText: String? = nil,
        topSalesLimit: Int = 3
    ) {
        self.statisticsService = statisticsService
        self.receipts = receipts
        self.searchText = searchText
        self.topSalesLimit = topSalesLimit
        calculateStatistics()
    }

    // MARK: - Public Methods
    func calculateStatistics() {
        totalSalesStats = calculatedTotalStats
        dailySalesStats = calculatedDailySales
        topItemSales = calculatedTopSales
    }

    // MARK: - Private Methods
    private var calculatedTotalStats: (total: Double, itemsSold: Int, averageCheck: Double)? {
        statisticsService.fetchTotalStats(receipts: filteredReceipts)
    }

    private var calculatedDailySales: [SalesStat] {
        statisticsService.fetchDailySales(receipts: filteredReceipts) ?? []
    }

    private var calculatedTopSales: [(item: Item, count: Int)] {
        statisticsService.fetchTopItemSales(
            receipts: receipts,
            searchText: searchText,
            limit: topSalesLimit
        )
    }

    private var filteredReceipts: [Receipt] {
        guard let searchText = searchText, !searchText.isEmpty else {
            return receipts
        }

        return receipts.filter { receipt in
            receipt.customerName.value.lowercased().contains(searchText.lowercased()) ||
            receipt.items.contains {
                $0.description.value.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
