//
//  FiltersView.swift
//  SalesReceipt
//
//  Created by Quasar on 17.01.2025.
//

import SwiftUI

struct FiltersView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var searchText: String
    let onDisappear: () -> Void

    var body: some View {
        VStack {
            DateRangePicker(
                startDate: $startDate,
                endDate: $endDate
            )
            SearchBar(
                titleSearch: "Search receipt...",
                searchText: $searchText,
                onClose: { print("SearchBar close in DailySalesView") }
            )
            .padding(.horizontal, 2)
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.easeInOut(duration: 0.3), value: true)
        .onDisappear {
            if !searchText.isEmpty ||
                startDate != Date() ||
                endDate != Date() {
                onDisappear()
            }
        }
    }
}
