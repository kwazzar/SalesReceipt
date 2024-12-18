//
//  DailySalesView.swift
//  SalesReceipt
//
//  Created by Quasar on 02.11.2024.
//

import SwiftUI
import SwiftUIIntrospect

#warning("добавить фильтри статиски по имени")
struct DailySalesView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DailySalesViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                DailySalesBar(title: "Daily Sales") {
                    presentationMode.wrappedValue.dismiss()
                } actionFilter: {
                    withAnimation {
                        viewModel.uiState.areFiltersApplied.toggle()
                    }
                } actionDelete: {
                    viewModel.uiState.showDeletePopup = true
                }
                
                if viewModel.uiState.areFiltersApplied {
                    filtersSearch()
                        .onDisappear {
                            if !viewModel.searchText.isEmpty ||
                                viewModel.startDate != Date() ||
                                viewModel.endDate != Date() {
                                viewModel.uiState.areFiltersApplied = false
                            }
                        }
                }
                ReceiptList(viewModel.visibleReceipts,
                            onReceiptTap: { receipt in
                    viewModel.selectedReceipt = receipt
                    viewModel.uiState.isShowingReceiptDetail = true
                })
            }
            .configurePopup(isPresented: $viewModel.uiState.showDeletePopup) {
                deleteConfirmationPopup()
            }
            .fullScreenCover(isPresented: Binding(
                get: { viewModel.uiState.isShowingReceiptDetail && viewModel.selectedReceipt != nil },
                set: { viewModel.uiState.isShowingReceiptDetail = $0 }
            )) {
                ReceiptDetailView(viewModel: ReceiptDetailViewModel(
                    receipt: viewModel.selectedReceipt!,
                    pdfManager: PDFManager(),
                    receiptManager: ReceiptManager(database: SalesDatabase.shared)
                ))
                .onDisappear {
                    viewModel.uiState.isShowingReceiptDetail = false
                }
            }
            BottomSheetView(state: $viewModel.uiState.currentState) {
                StatisticsView(
                    bottomSheetState: $viewModel.uiState.currentState,
                    actionClosed: {
                        withAnimation {
                            viewModel.uiState.currentState = .closed
                        }
                    },
                    isButtonVisible: viewModel.uiState.currentState != .closed,
                    receipts: viewModel.visibleReceipts,
                    searchText: viewModel.searchText,
                    statisticsService: viewModel.statisticsService
                )
                .frame(height: viewModel.bottomSheetHeight)
            }
        }
    }
    
    //MARK: - deleteConfirmationPopup
    private func deleteConfirmationPopup() -> some View {
        VStack(spacing: 20) {
            Text("Delete All Receipts")
                .font(.headline)
            Text("Are you sure you want to delete all receipts? This action cannot be undone.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            HStack {
                Button(action: {
                    viewModel.uiState.showDeletePopup = false
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .innerStroke(inset: 1)
                }
                
                Button(action: {
                    viewModel.clearAllReceipts()
                    viewModel.uiState.showDeletePopup = false
                }) {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .innerStroke(inset: 1)
                }
            }
        }
        .padding()
        .innerStroke(cornerRadius: 12, lineWidth: 2, color: .black, inset: 1)
        .background(Color.white)
        .cornerRadius(12)
        .padding(40)
        .offset(y: 40)
    }
    
    //MARK: - filtersSearch
    private func filtersSearch() -> some View {
        VStack {
            customDatePicker()
            SearchBar(titleSearch: "Search receipt...", searchText: $viewModel.searchText) {
                print("SearchBar close in DailySalesView")
            }
            .padding(.horizontal, 2)
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.easeInOut(duration: 0.3), value: viewModel.uiState.areFiltersApplied)
    }
    
    //MARK: - customDatePicker
    private func customDatePicker() -> some View {
        HStack(spacing: 3) {
            CustomDatePickerView(title: "Start", selectedDate: $viewModel.startDate)
                .onChange(of: viewModel.startDate) { newStartDate in
                    if viewModel.endDate < newStartDate {
                        viewModel.endDate = newStartDate
                    }
                }
            
            CustomDatePickerView(title: "End", selectedDate: $viewModel.endDate)
                .onChange(of: viewModel.endDate) { newEndDate in
                    if newEndDate < viewModel.startDate {
                        viewModel.endDate = viewModel.startDate
                    }
                }
        }
        .padding(-5)
    }
}

struct DailySalesView_Previews: PreviewProvider {
    static var previews: some View {
        DailySalesView(viewModel: DailySalesViewModel(receiptManager: MockReceiptManager() , statisticsService: StatisticsManager()))
    }
}
