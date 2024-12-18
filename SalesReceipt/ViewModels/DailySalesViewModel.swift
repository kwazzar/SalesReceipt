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
    @Published var startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date() {
        didSet { updateVisibleReceipts() }
    }
    @Published var endDate = Date() {
        didSet { updateVisibleReceipts() }
    }
    @Published var searchText = "" {
        didSet { updateVisibleReceipts() }
    }
    @Published var selectedReceipt: Receipt?
    @Published var uiState = DailySalesUIState()

    @Published var totalSalesStats: (total: Double, itemsSold: Int, averageCheck: Double)?
    @Published var dailySalesStats: [SalesStat] = []
    @Published var topItemSales: [(item: Item, count: Int)] = []
    @Published var visibleReceipts: [Receipt] = [] // Видимые рецепты

    private let receiptManager: ReceiptDatabaseAPI
    let statisticsService: StatisticsAPI
    private var allReceipts: [Receipt] = [] // Все данные из базы

    let bottomSheetHeight: CGFloat = UIScreen.main.bounds.height * 0.9

    init(
        receiptManager: ReceiptDatabaseAPI,
        statisticsService: StatisticsAPI
    ) {
        self.receiptManager = receiptManager
        self.statisticsService = statisticsService
        loadAllReceipts()
        updateVisibleReceipts()
        fetchStatistics()
    }

    // Загружаем все чеки из базы при старте
    private func loadAllReceipts() {
        allReceipts = (try? receiptManager.fetchAllReceipts()) ?? []
    }

    private func updateVisibleReceipts() {
        print("🔄 Обновление видимых рецептов")
        print("📅 Период: \(startDate) - \(endDate)")
        print("🔍 Текст поиска: \(searchText)")

        visibleReceipts = receiptManager.filter(
            receipts: allReceipts,
            startDate: startDate,
            endDate: endDate,
            searchText: searchText
        )

        print("✅ Количество видимых рецептов: \(visibleReceipts.count)")
        fetchStatistics()
    }

    private func fetchStatistics() {
        print("📊 Получение статистики")
        totalSalesStats = statisticsService.fetchTotalStats(receipts: visibleReceipts)
        dailySalesStats = statisticsService.fetchDailySales(receipts: visibleReceipts) ?? []
        topItemSales = statisticsService.fetchTopItemSales(receipts: visibleReceipts, searchText: searchText, limit: 3)
    }

    func clearAllReceipts() {
        do {
            try receiptManager.clearAllReceipts()
            allReceipts.removeAll()
            updateVisibleReceipts()
        } catch {
            print("Ошибка при очистке чеков: \(error)")
        }
    }
}
