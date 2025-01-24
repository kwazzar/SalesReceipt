//
//  ContentView.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import SwiftUI

struct SalesView: View {
    @StateObject private var viewModel: SalesViewModel
    @StateObject private var uiState: SalesUIState
    @StateObject private var searchState: SearchState
    
    init(viewModel: SalesViewModel = SalesViewModel(
        receiptManager: ReceiptManager(database: SalesDatabase.shared), itemManager: ItemManager()
    )) {
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
                BottomBar(showingDailySales: $uiState.showingDailySales,
                          clearAllAction: { viewModel.clearAll() },
                          checkoutAction: { viewModel.checkout() },
                          isCheckoutDisabled: viewModel.currentItems.isEmpty
                )
            }
            .blur(radius: viewModel.uiState.isPopupVisible ? 3 : 0)
            popupOverlay
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
    
    private var popupOverlay: some View {
        Group {
            if viewModel.uiState.isPopupVisible {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { viewModel.uiState.isPopupVisible = false }
                
                CustomerNamePopup(viewModel: viewModel)
                    .transition(.scale)
            }
        }
    }
}

struct SalesView_Previews: PreviewProvider {
    static var previews: some View {
        SalesView()
    }
}
