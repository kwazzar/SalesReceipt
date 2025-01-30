//
//  ContentView.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import SwiftUI

struct SalesView: View {
    @StateObject var viewModel: SalesViewModel
    @StateObject var uiState: SalesUIState
    @StateObject var searchState: SearchState
    
    init(viewModel: SalesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _uiState = StateObject(wrappedValue: viewModel.uiState)
        _searchState = StateObject(wrappedValue: viewModel.searchState)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                searchBar
                CarouselView(items: viewModel.searchState.filteredItems) { item in
                    viewModel.addItem(item)
                }
                receiptView
                bottomBar
            }
            .blur(radius: viewModel.uiState.isPopupVisible ? 3 : 0)
            popupEnterCustomerNameOverlay
        }
        .animation(.easeInOut, value: viewModel.uiState.isPopupVisible)
    }
}

//MARK: - Extension
extension SalesView {
    private var searchBar: some View {
        SearchBar(
            titleSearch: "Search items...",
            searchText: Binding(
                get: { viewModel.searchState.searchText.text },
                set: { newText in
                    let query = SearchQuery(text: newText)
                    viewModel.searchState.searchText = query
                    viewModel.searchState.updateFilteredItems(for: query)
                }
            ),
            onClose: {
                viewModel.searchState.resetSearch()
            }
        )
    }
    
    private var receiptView: some View {
        ReceiptView(
            items: viewModel.currentItems,
            total: viewModel.total.value,
            uiState: viewModel.uiState,
            onDeleteItem: viewModel.deleteItem,
            onDecrementItem: viewModel.decrementItem
        )
    }
    
    private var popupEnterCustomerNameOverlay: some View {
        Group {
            if viewModel.uiState.isPopupVisible {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { viewModel.uiState.isPopupVisible = false }
                
                CustomerNamePopup(inputName: $viewModel.popupInputName,
                                  anonymousButton: {
                    viewModel.finalizeCheckout(with: CustomerName(nil))
                    viewModel.uiState.isPopupVisible = false
                }, saveNameButton: {
                    viewModel.finalizeCheckout(with: CustomerName(viewModel.popupInputName))
                    viewModel.uiState.isPopupVisible = false
                }, onBack: { viewModel.uiState.isPopupVisible = false
                    viewModel.popupInputName = ""
                })
                .transition(.scale)
            }
        }
    }
    
    private var bottomBar: some View {
        BottomBar(showingDailySales: $uiState.showingDailySales,
                  clearAllAction: { viewModel.clearAll() },
                  checkoutAction: { viewModel.checkout() },
                  isCheckoutDisabled: viewModel.currentItems.isEmpty,
                  dailySalesFactory: DefaultDailySalesFactory()
        )
    }
}

struct SalesView_Previews: PreviewProvider {
    static var previews: some View {

        let salesFactory = MockSalesFactory()
        salesFactory.createSalesView()
    }
}
