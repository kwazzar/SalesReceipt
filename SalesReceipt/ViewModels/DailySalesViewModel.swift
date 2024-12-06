//
//  DailySalesViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 12.11.2024.
//

import Foundation

final class DailySalesViewModel: ObservableObject {
    @Published var startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    @Published var endDate = Date()
    @Published var searchtext = ""
    @Published var showDeletePopup = false
    @Published var areFiltersApplied = false
    @Published var selectedReceipt: Receipt?
    @Published var isShowingReceiptDetail = false
    
    private let database: SalesDatabaseProtocol
    
    init(database: SalesDatabaseProtocol) {
        self.database = database
    }
    
    var filteredReceipts: [Receipt] {
        let allReceipts = (try? database.fetchAllReceipts()) ?? []
        
        guard areFiltersApplied else {
            return allReceipts
        }
        
        return Receipt.filter(
            to: allReceipts,
            startDate: startDate,
            endDate: endDate,
            searchText: searchtext
        )
    }
    
    func clearAllReceipts() {
        do {
            try database.clearAllReceipts()
        } catch {
            print(error)
        }
    }
}
