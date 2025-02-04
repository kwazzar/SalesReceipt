//
//  DailySalesView.swift
//  SalesReceipt
//
//  Created by Quasar on 02.11.2024.
//

import SwiftUI

struct DailySalesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: DailySalesViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                header
                if viewModel.uiState.areFiltersApplied {
                    filtersView
                }
                receiptList
            }
            .configurePopup(isPresented: $viewModel.uiState.showDeletePopup,
                            content: { deletePopup })
            .fullScreenCover(isPresented: viewModel.receiptDetailBinding,
                             content: { receiptDetailView }
            )
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
            onDismiss: { presentationMode.wrappedValue.dismiss() },
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

    private var receiptList: some View {
        ReceiptList(viewModel.visibleReceipts,
                    onReceiptTap: viewModel.showReceiptDetail,
                    onReceiptDelete: viewModel.deleteReceipt
        )
    }

    private var deletePopup: some View {
        DeleteConfirmationPopup(
            isPresented: $viewModel.uiState.showDeletePopup,
            onConfirm: viewModel.clearAllReceipts
        )
    }

    private var receiptDetailView: some View {
        Group {
            if let receipt = viewModel.selectedReceipt {
                DefaultReceiptDetailFactory()
                    .createReceiptDetailView(receipt: receipt)
                    .onDisappear { viewModel.uiState.isShowingReceiptDetail = false }
            }
        }
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
