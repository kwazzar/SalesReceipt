//
//  DailySalesView.swift
//  SalesReceipt
//
//  Created by Quasar on 02.11.2024.
//

import SwiftUI
import SwiftUIIntrospect
import PopupView

struct DailySalesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: DailySalesViewModel
    
    var body: some View {
        VStack {
            DailySalesBar(title: "Daily Sales") {
                presentationMode.wrappedValue.dismiss()
            } actionFilter: {
                withAnimation {
                    viewModel.areFiltersApplied.toggle()
                }
            } actionDelete:  {
                viewModel.showDeletePopup = true
            }
            
            if viewModel.areFiltersApplied {
                filtersSearch()
                    .onDisappear {
                        if !viewModel.searchtext.isEmpty || viewModel.startDate != Date() || viewModel.endDate != Date() {
                            viewModel.areFiltersApplied = false
                        }
                    }
            }
            ReceiptList(viewModel.filteredReceipts,  onReceiptTap: { receipt in
                viewModel.selectedReceipt = receipt
                viewModel.isShowingReceiptDetail = true
            })
        }
        .popup(isPresented: $viewModel.showDeletePopup) {
            deleteConfirmationPopup()
        } customize: {
            $0
                .type(.toast)
                .position(.top)
                .animation(.easeInOut)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        }
        .fullScreenCover(isPresented: Binding(
            get: { viewModel.isShowingReceiptDetail && viewModel.selectedReceipt != nil },
            set: { viewModel.isShowingReceiptDetail = $0 }
        )) {
            ReceiptDetailView(viewModel: ReceiptDetailViewModel(
                receipt: viewModel.selectedReceipt!,
                pdfManager: PDFManager(),
                databaseManager: ReceiptManager(database: SalesDatabase.shared)
            ))
            .onDisappear {
                viewModel.isShowingReceiptDetail = false
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
                    viewModel.showDeletePopup = false
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
                    viewModel.showDeletePopup = false
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
            
            SearchBar(titleSearch: "Search receipt...", searchText: $viewModel.searchtext) {
                print("SearchBar close in DailySalesView")
            }
            .padding(.horizontal, 2)
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.easeInOut(duration: 0.3), value: viewModel.areFiltersApplied)
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
        DailySalesView(viewModel: DailySalesViewModel(database: SalesDatabase.shared))
    }
}
