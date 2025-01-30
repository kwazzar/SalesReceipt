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
                DailySalesHeader(
                    title: "DailySales",
                    onDismiss: { presentationMode.wrappedValue.dismiss() },
                    onFilterToggle: viewModel.toggleFilters,
                    onDeleteRequest: { viewModel.uiState.showDeletePopup = true }
                )
                if viewModel.uiState.areFiltersApplied {
                    FiltersView(
                        startDate: $viewModel.startDate,
                        endDate: $viewModel.endDate,
                        searchText: $viewModel.searchText,
                        onDisappear: viewModel.handleFiltersDisappear
                    )
                }

                ReceiptList(viewModel.visibleReceipts,
                            onReceiptTap: viewModel.showReceiptDetail,
                            onReceiptDelete: viewModel.deleteReceipt
                )
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
    private var deletePopup: some View {
        DeleteConfirmationPopup(
            isPresented: $viewModel.uiState.showDeletePopup,
            onConfirm: viewModel.clearAllReceipts
        )
    }
    private var receiptDetailView: some View {
        Group {
            if let receipt = viewModel.selectedReceipt {
                ReceiptDetailView(
                    viewModel: ReceiptDetailViewModel(
                        receipt: receipt,
                        pdfManager: PDFManager(),
                        receiptManager: ReceiptManager(database: SalesDatabase.shared)
                    )
                )
                .onDisappear { viewModel.uiState.isShowingReceiptDetail = false }
            }
        }
    }

    #warning("при першому піднятті statisticsView підлагує")
    private var statisticsView: some View {
        StatisticsView(
            bottomSheetState: $viewModel.uiState.currentState,
            actionClosed: viewModel.closeStatistics,
            isButtonVisible: viewModel.uiState.currentState != .closed,
            receipts: viewModel.visibleReceipts,
            searchText: viewModel.searchText,
            statisticsService: viewModel.statisticsService
        )
    }
}


struct DailySalesView_Previews: PreviewProvider {
    static var previews: some View {
        DailySalesView(viewModel: DailySalesViewModel(receiptManager: MockReceiptManager(), statisticsService: StatisticsManager()))
    }
}
