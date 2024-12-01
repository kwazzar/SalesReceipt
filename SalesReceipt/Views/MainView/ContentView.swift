//
//  ContentView.swift
//  SalesReceipt
//
//  Created by Quasar on 01.11.2024.
//

import SwiftUI

#warning("Добавить статистику продаж")
#warning("сделать екран создания customera")

struct ContentView: View {
    @StateObject private var viewModel = SalesViewModel()

    var body: some View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
