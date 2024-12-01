//
//  DailySalesViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 12.11.2024.
//

import Foundation

final class DailySalesViewModel: ObservableObject {
    let database = SalesDatabase.shared
    @Published var startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    @Published var endDate = Date()
    @Published var searchtext = ""
    @Published var showDeletePopup = false
    @Published var areFiltersApplied = false
    @Published var selectedReceipt: Receipt?

    var filteredReceipts: [Receipt] {
        let allReceipts = database.getAllReceipts()

        // Если фильтры не применены, возвращаем все чеки
        if !areFiltersApplied {
            return allReceipts
        }

        // Применяем фильтрацию по дате
        let receiptsWithFilters = allReceipts.filter { receipt in
            return receipt.date >= startDate && receipt.date <= endDate
        }

        // Применяем фильтрацию по поисковому тексту
        if searchtext.isEmpty {
            return receiptsWithFilters
        } else {
            return receiptsWithFilters.filter { receipt in
                let customerName = receipt.customerName.value 
                return customerName.lowercased().contains(searchtext.lowercased())
            }
        }
    }
}
