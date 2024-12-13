//
//  DailySalesViewModel.swift
//  SalesReceipt
//
//  Created by Quasar on 12.11.2024.
//

import UIKit.UIScreen

final class DailySalesViewModel: ObservableObject {
    @Published var startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    @Published var endDate = Date()
    @Published var searchtext = ""
    @Published var selectedReceipt: Receipt?
    @Published var uiState = DailySalesUIState()
    let bottomSheetHeight: CGFloat = UIScreen.main.bounds.height * 0.8
    
    private let database: SalesDatabaseProtocol
    
    init(database: SalesDatabaseProtocol) {
        self.database = database
    }
    
    var filteredReceipts: [Receipt] {
        let allReceipts = (try? database.fetchAllReceipts()) ?? []
        
        guard uiState.areFiltersApplied else {
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

//MARK: - DailySalesUIState
struct DailySalesUIState {
    var showDeletePopup: Bool = false
    var areFiltersApplied: Bool = false
    var isShowingReceiptDetail: Bool = false
    var currentState: BottomSheetState = .closed
}
