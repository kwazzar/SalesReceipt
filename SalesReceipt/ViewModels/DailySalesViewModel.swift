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
    @Published var visibleReceipts: [Receipt] = []
    @Published var uiState = DailySalesUIState() {
        didSet {
             if uiState.areFiltersApplied && uiState.currentState == .expanded {
                 uiState.currentState = .withFilters
             }
             else if !uiState.areFiltersApplied && uiState.currentState == .withFilters {
                 uiState.currentState = .expanded
             }
         }
    }

    private let receiptManager: ReceiptDatabaseAPI
    let statisticsService: StatisticsAPI
    private var allReceipts: [Receipt] = []

    let bottomSheetHeight: CGFloat = UIScreen.main.bounds.height * 0.9

    init(
        receiptManager: ReceiptDatabaseAPI,
        statisticsService: StatisticsAPI
    ) {
        self.receiptManager = receiptManager
        self.statisticsService = statisticsService
        loadAllReceipts()
        updateVisibleReceipts()
    }

    private func loadAllReceipts() {
        allReceipts = (try? receiptManager.fetchAllReceipts()) ?? []
    }

    private func updateVisibleReceipts() {
        visibleReceipts = receiptManager.filter(
            receipts: allReceipts,
            startDate: startDate,
            endDate: endDate,
            searchText: searchText
        )
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
