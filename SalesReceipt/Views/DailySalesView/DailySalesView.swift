//
//  DailySalesView.swift
//  SalesReceipt
//
//  Created by Quasar on 02.11.2024.
//

import SwiftUI

struct DailySalesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: DailySalesViewModel

    var body: some View {
        DailySalesContainer(
            viewModel: viewModel,
            presentationMode: presentationMode
        )
    }
}

struct DailySalesView_Previews: PreviewProvider {
    static var previews: some View {
        DailySalesView(viewModel: DailySalesViewModel(receiptManager: MockReceiptManager(), statisticsService: StatisticsManager()))
    }
}
