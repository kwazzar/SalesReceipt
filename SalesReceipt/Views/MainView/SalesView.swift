//
//  ContentView.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import SwiftUI

struct SalesView: View {
    @StateObject private var viewModel = SalesViewModel(
        ReceiptManager(database: SalesDatabase.shared))
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                SearchBar(titleSearch: "Search items...", searchText: Binding(
                    get: { viewModel.searchText.text },
                    set: { viewModel.searchText = SearchQuery(text: $0); viewModel.updateFilteredItems(for: SearchQuery(text: $0)) }
                ), actionClose: {
                    viewModel.searchText = SearchQuery(text: "")
                    viewModel.updateFilteredItems(for: SearchQuery(text: ""))
                })
                CarouselView(viewModel: viewModel)
                ReceiptView(items: viewModel.currentItems, total: viewModel.total.value)
                BottomBar(viewModel: viewModel)
            }
            .blur(radius: viewModel.isPopupVisible ? 3 : 0)
            
            if viewModel.isPopupVisible {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        viewModel.isPopupVisible = false
                    }
                CustomerNamePopup(viewModel: viewModel)
                    .transition(.scale)
            }
        }
        .animation(.easeInOut, value: viewModel.isPopupVisible)
    }
}

struct SalesView_Previews: PreviewProvider {
    static var previews: some View {
        SalesView()
    }
}
