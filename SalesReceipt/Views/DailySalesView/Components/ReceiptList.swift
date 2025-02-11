//
//  ReceiptList.swift
//  SalesReceipt
//
//  Created by Quasar on 04.12.2024.
//

import SwiftUI

struct ReceiptList: View {
   private var receipts: [Receipt]
   private var onReceiptTap: (Receipt) -> Void
   private var onReceiptDelete: (Receipt) -> Void
    
    init(_ receipts: [Receipt],
         onReceiptTap: @escaping (Receipt) -> Void,
         onReceiptDelete: @escaping (Receipt) -> Void) {
        self.receipts = receipts.sorted { $0.date > $1.date }
        self.onReceiptTap = onReceiptTap
        self.onReceiptDelete = onReceiptDelete
    }
    
    var body: some View {
        ScrollView {
            if receipts.isEmpty {
                VStack {
                    Spacer()
                    Image(systemName: "doc.text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                    Text("No receipt in recent days")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
                .frame(maxHeight: .infinity)
            } else {
                ForEach(receipts, id: \.id) { receipt in
                    CustomerCard(id: receipt.id,
                                 name: receipt.customerName.value,
                                 date: receipt.date,
                                 total: receipt.total,
                                 items: receipt.items.reduce(0) { $0 + $1.quantity },
                                 infoAction: { onReceiptTap(receipt) },
                                 deleteAction: { onReceiptDelete(receipt) })
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                }
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

struct ReceiptList_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptList(testReceipts, onReceiptTap: {_ in  }, onReceiptDelete: {_ in })
    }
}
