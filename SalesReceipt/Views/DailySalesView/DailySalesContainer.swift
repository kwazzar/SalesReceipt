//
//  DailySalesContainer.swift
//  SalesReceipt
//
//  Created by Quasar on 17.01.2025.
//

import SwiftUI

struct DailySalesContainer: View {
    @ObservedObject var viewModel: DailySalesViewModel
    let presentationMode: Binding<PresentationMode>

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

                ReceiptList( viewModel.visibleReceipts,
                    onReceiptTap: viewModel.showReceiptDetail,
                    onReceiptDelete: viewModel.deleteReceipt
                )
            }
            .configurePopup(isPresented: $viewModel.uiState.showDeletePopup,
                            content: { deletePopup })
            .fullScreenCover(
                isPresented: viewModel.receiptDetailBinding,
                content: { receiptDetailView }
            )

            BottomStatisticsSheet(state: $viewModel.uiState.currentState) {
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
    }

    private var deletePopup: some View {
        DeleteConfirmationPopup(
            isPresented: $viewModel.uiState.showDeletePopup,
            onConfirm: viewModel.clearAllReceipts
        )
    }

    private var receiptDetailView: some View {
        ReceiptDetailView(
            viewModel: ReceiptDetailViewModel(
                receipt: viewModel.selectedReceipt!,
                pdfManager: PDFManager(),
                receiptManager: ReceiptManager(database: SalesDatabase.shared)
            )
        )
        .onDisappear { viewModel.uiState.isShowingReceiptDetail = false }
    }
}
