//
//  DailySalesViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 12.11.2024.
//

import UIKit.UIScreen

struct DailySalesUIState {
    var showDeletePopup: Bool = false
    var areFiltersApplied: Bool = false
    var isShowingReceiptDetail: Bool = false
    var currentState: BottomSheetState = .closed
}

final class DailySalesViewModel: ObservableObject {
    @Published var startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    @Published var endDate = Date()
    @Published var searchText = ""
    @Published var selectedReceipt: Receipt?
    @Published var uiState = DailySalesUIState()

    @Published var totalSalesStats: (total: Double, itemsSold: Int, averageCheck: Double)?
    @Published var dailySalesStats: [SalesStat] = []
    @Published var topItemSales: [(item: Item, count: Int)] = []

    private let receiptManager: ReceiptDatabaseAPI
    private let statisticsService: StatisticsAPI

    let bottomSheetHeight: CGFloat = UIScreen.main.bounds.height * 0.8

    init(
        receiptManager: ReceiptDatabaseAPI,
        statsService: StatisticsAPI
    ) {
        self.receiptManager = receiptManager
        self.statisticsService = statsService
        fetchStatistics()
    }

    var filteredReceipts: [Receipt] {
        guard uiState.areFiltersApplied else {
            return (try? receiptManager.fetchAllReceipts()) ?? []
        }

        return receiptManager.filterReceipts(
            startDate: startDate,
            endDate: endDate,
            searchText: searchText
        )
    }
    
    func clearAllReceipts() {
        do {
            try receiptManager.clearAllReceipts()
        } catch {
            print("Ошибка при очистке чеков: \(error)")
        }
    }

    private func fetchStatistics() {
        totalSalesStats = statisticsService.fetchTotalStats()
        dailySalesStats = statisticsService.fetchDailySales() ?? []
        topItemSales = statisticsService.fetchTopItemSales(limit: 6)
    }

    var filteredStatistics: [SalesStat] {
        dailySalesStats.filter { stat in
            stat.date >= startDate && stat.date <= endDate
        }
    }
}
