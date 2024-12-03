//
//  ReceiptList.swift
//  SalesReceipt
//
//  Created by Quasar on 04.12.2024.
//

import SwiftUI

struct ReceiptList: View {
    var receipts: [Receipt]
    var onReceiptTap: (Receipt) -> Void

    init(_ receipts: [Receipt],
         onReceiptTap: @escaping (Receipt) -> Void) {
        self.receipts = receipts.sorted { $0.date > $1.date }
        self.onReceiptTap = onReceiptTap
    }

    var body: some View {
        ScrollView {
            ForEach(receipts, id: \.id) { receipt in

                CustomerCard(id: receipt.id,
                             name: receipt.customerName.value,
                             date: receipt.date,
                             total: receipt.total,
                             items: receipt.items.count, infoAction: {
                    onReceiptTap(receipt)
                })
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
            }
        }
        .introspect(.scrollView, on: .iOS(.v15), .iOS(.v16), .iOS(.v17), .iOS(.v18), customize: { scroll in
            scroll.bounces = false
        })
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .padding(.horizontal, 10)
    }
}

//struct ReceiptList_Previews: PreviewProvider {
//    static var previews: some View {
//        ReceiptList()
//    }
//}
