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
                SearchBar(titleSearch: "Search items...", searchText: Binding(
                    get: { viewModel.searchState.searchText.text },
                    set: { newText in
                        viewModel.searchState.searchText = SearchQuery(text: newText)
                        viewModel.searchState.updateFilteredItems(for: SearchQuery(text: newText))
                    }
                ), actionClose: {
                    viewModel.searchState.searchText = SearchQuery(text: "")
                    viewModel.searchState.updateFilteredItems(for: SearchQuery(text: ""))
                })
                
                CarouselView(viewModel: viewModel)
                
                ReceiptView(
                    items: viewModel.currentItems,
                    total: viewModel.total.value,
                    uiState: viewModel.uiState,
                    onDeleteItem: viewModel.deleteItem,
                    onDecrementItem: viewModel.decrementItem
                )
                BottomBar(viewModel: viewModel)
            }
            .blur(radius: viewModel.uiState.isPopupVisible ? 3 : 0)
            
            if viewModel.uiState.isPopupVisible {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        viewModel.uiState.isPopupVisible = false
                    }
                CustomerNamePopup(viewModel: viewModel)
                    .transition(.scale)
            }
        }
        .animation(.easeInOut, value: viewModel.uiState.isPopupVisible)
    }
}

struct SalesView_Previews: PreviewProvider {
    static var previews: some View {
        SalesView()
    }
}
