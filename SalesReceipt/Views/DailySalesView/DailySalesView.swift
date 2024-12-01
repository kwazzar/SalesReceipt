//
//  DailySalesView.swift
//  SalesReceipt
//
//  Created by Quasar on 02.11.2024.
//

import SwiftUI
import SwiftUIIntrospect
import PopupView
#warning("Реализовать поиск по имени")

struct DailySalesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = DailySalesViewModel()
    @State private var isShowingReceiptDetail = false
    
    var body: some View {
        VStack {
            DailySalesBar(title: "Daily Sales") {
                presentationMode.wrappedValue.dismiss()
            } actionFilter: {
                withAnimation { // Оборачиваем в анимацию
                    viewModel.areFiltersApplied.toggle()
                }
            } actionDelete:  {
                viewModel.showDeletePopup = true
            }
            
            if viewModel.areFiltersApplied {
                filtersSearch()
                    .onDisappear {
                        // Устанавливаем флаг, если фильтры применены
                        if !viewModel.searchtext.isEmpty || viewModel.startDate != Date() || viewModel.endDate != Date() {
                            viewModel.areFiltersApplied = false
                        }
                    }
            }
            ReceiptList(viewModel.filteredReceipts,  onReceiptTap: { receipt in
                viewModel.selectedReceipt = receipt
                isShowingReceiptDetail = true
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
        .fullScreenCover(isPresented: $isShowingReceiptDetail) {
            ReceiptDetailView(viewModel: ReceiptDetailViewModel(
                receipt: viewModel.selectedReceipt!,
                pdfGenerator: PDFGenerator()
            ))
            .onDisappear {
                isShowingReceiptDetail = false
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
                    viewModel.database.clearAllReceipts()
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
        .transition(.move(edge: .top).combined(with: .opacity)) // Анимация появления сверху с изменением прозрачности
        .animation(.easeInOut(duration: 0.3), value: viewModel.areFiltersApplied) // Настройка анимации
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

//MARK: - ReceiptList
struct ReceiptList: View {
    var receipts: [Receipt]
    var onReceiptTap: (Receipt) -> Void
    private let generator = PDFGenerator()
    
    init(_ receipts: [Receipt],
         onReceiptTap: @escaping (Receipt) -> Void) {
        self.receipts = receipts
        self.onReceiptTap = onReceiptTap
    }
    
    var body: some View {
        ScrollView {
            ForEach(receipts, id: \.id) { receipt in
                CustomerCard(id: receipt.id,
                             name: receipt.customerName.value,
                             date: receipt.date,
                             total: receipt.total,
                             items: receipt.items.count, infoAction: {
                    onReceiptTap(receipt)
                })
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
            }
        }
        .introspect(.scrollView, on: .iOS(.v15), .iOS(.v16), .iOS(.v17), .iOS(.v18), customize: { scroll in
            scroll.bounces = false
        })
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .padding(.horizontal, 10)
    }
}

//MARK: - CustomDatePickerView
struct CustomDatePickerView: View {
    let title: String
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .padding(6)
                .background(Color.white)
                .cornerRadius(8)
                .innerStroke(cornerRadius: 10, lineWidth: 2, color: .black, inset: 6)
        }
        .padding(.horizontal, 10)
    }
}

//MARK: - DailySalesBar
struct DailySalesBar: View {
    var title: String
    var actionBack: () -> Void
    var actionFilter: () -> Void
    var actionDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: actionBack) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Text(title)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)
            
            Button(action: actionFilter) {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(BorderlessButtonStyle())
            Button(action: actionDelete) {
                Image(systemName: "trash")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.horizontal, 10)
        .frame(height: 50)
    }
}

struct DailySalesView_Previews: PreviewProvider {
    static var previews: some View {
        DailySalesView()
    }
}
