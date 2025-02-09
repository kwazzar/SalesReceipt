//
//  DailySalesViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 12.11.2024.
//

import UIKit.UIScreen
import SwiftUI
import Combine

struct DailySalesUIState: Equatable {
    var showDeletePopup: Bool = false
    var areFiltersApplied: Bool = false
    var currentState: BottomSheetState = .closed
}

#warning("viewModel is Overloaded")
final class DailySalesViewModel: ObservableObject {
    @Published var uiState = DailySalesUIState()
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var searchText: String = ""
    @Published private(set) var visibleReceipts: [Receipt] = []
    @Published var selectedReceipt: Receipt?
    @Published private(set) var isLoadingMore = false
    
    private let receiptManager: ReceiptDatabaseAPI
    let statisticsService: StatisticsAPI
    private var allReceipts: [Receipt] = []
    let bottomSheetHeight: CGFloat
    private var cancellables = Set<AnyCancellable>()
    
    init(
        receiptManager: ReceiptDatabaseAPI,
        statisticsService: StatisticsAPI,
        screenHeight: CGFloat = UIScreen.main.bounds.height
    ) {
        self.receiptManager = receiptManager
        self.statisticsService = statisticsService
        self.bottomSheetHeight = screenHeight * 0.9
        self.startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        self.endDate = Date()
        
        setupPublishers()
        loadAllReceipts()
        updateVisibleReceipts()
    }
    
    private func setupPublishers() {
        Publishers.CombineLatest3($startDate, $endDate, $searchText)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _, _, _ in
                self?.updateVisibleReceipts()
            }
            .store(in: &cancellables)
        
        $uiState
            .map(\.currentState)
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] newState in
                guard let self = self else { return }
                
                if newState == .expanded && self.uiState.areFiltersApplied {
                    DispatchQueue.main.async {
                        withAnimation {
                            self.uiState.currentState = .withFilters
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Interface
    func closeStatistics() {
        withAnimation {
            uiState.currentState = .closed
        }
    }
    
    // MARK: - Receipt Management
    func clearAllReceipts() {
        do {
            try receiptManager.clearAllReceipts()
            allReceipts.removeAll()
            updateVisibleReceipts()
        } catch {
            print("Error clearing receipts: \(error)")
        }
    }
    
    func deleteReceipt(_ receipt: Receipt) {
        do {
            try receiptManager.deleteReceipt(receipt)
            allReceipts.removeAll { $0.id == receipt.id }
            updateVisibleReceipts()
        } catch {
            print("Error deleting receipt: \(error)")
        }
    }
    
    // MARK: - Private Methods
    private func loadAllReceipts() {
        do {
            // First load last 10 receipts
            allReceipts = try receiptManager.fetchLastReceipts(limit: 10)
            updateVisibleReceipts()
            
            // Then load all receipts asynchronously
            isLoadingMore = true
            Task {
                do {
                    let allLoadedReceipts = try await receiptManager.fetchAllReceipts()
                    await MainActor.run {
                        self.allReceipts = allLoadedReceipts
                        self.updateVisibleReceipts()
                        self.isLoadingMore = false
                    }
                } catch {
                    print("Error loading all receipts: \(error)")
                    await MainActor.run {
                        self.isLoadingMore = false
                    }
                }
            }
        } catch {
            print("Error loading initial receipts: \(error)")
        }
    }
    
    private func updateVisibleReceipts() {
        visibleReceipts = receiptManager.filter(
            receipts: allReceipts,
            startDate: startDate,
            endDate: endDate,
            searchText: searchText
        )
    }
}

// MARK: - Filter Methods
extension DailySalesViewModel {
    func handleFiltersDisappear() {
        if uiState.currentState == .withFilters {
            withAnimation {
                uiState.currentState = .expanded
            }
        }
    }
    
    func toggleFilters() {
        withAnimation(.easeInOut(duration: 0.3)) {
            uiState.areFiltersApplied.toggle()
            
            if uiState.areFiltersApplied && uiState.currentState == .expanded {
                uiState.currentState = .withFilters
            } else if !uiState.areFiltersApplied && uiState.currentState == .withFilters {
                uiState.currentState = .expanded
            }
        }
    }
}
