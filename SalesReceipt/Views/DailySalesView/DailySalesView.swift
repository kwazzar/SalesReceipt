//
//  DailySalesView.swift
//  SalesReceipt
//
//  Created by Quasar on 02.11.2024.
//

import SwiftUI

struct DailySalesView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @StateObject var viewModel: DailySalesViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                header
                if viewModel.uiState.areFiltersApplied {
                    filtersView
                }
                ReceiptList(viewModel.visibleReceipts,
                            onReceiptTap: { receipt in
                    coordinator.navigateTo(.receiptDetail(receipt))
                },
                            onReceiptDelete: viewModel.deleteReceipt
                )
            }
            .configurePopup(isPresented: $viewModel.uiState.showDeletePopup,
                            content: { deletePopup })
            BottomStatisticsSheet(state: $viewModel.uiState.currentState,
                                  content: { statisticsView })
        }
    }
}

//MARK: - Extension
extension DailySalesView {
    private var header: some View {
        DailySalesHeader(
            title: "DailySales",
            onDismiss: { coordinator.dismiss() },
            onFilterToggle: viewModel.toggleFilters,
            onDeleteRequest: { viewModel.uiState.showDeletePopup = true }
        )
    }
    
    private var filtersView: some View {
        FiltersView(
            startDate: $viewModel.startDate,
            endDate: $viewModel.endDate,
            searchText: $viewModel.searchText,
            onDisappear: viewModel.handleFiltersDisappear
        )
    }
    
    private var deletePopup: some View {
        DeleteConfirmationPopup(
            isPresented: $viewModel.uiState.showDeletePopup,
            onConfirm: viewModel.clearAllReceipts
        )
    }
    
    private var statisticsView: some View {
        StatisticsView(viewModel: StatisticsViewModel(statisticsService: StatisticsManager(), receipts: viewModel.visibleReceipts), bottomSheetState: $viewModel.uiState.currentState, actionClosed: viewModel.closeStatistics, isButtonVisible: viewModel.uiState.currentState != .closed)
    }
}

struct DailySalesView_Previews: PreviewProvider {
    static var previews: some View {
        
        let dailySales = MockDailySalesFactory()
        dailySales.createDailySalesView()
    }
}
