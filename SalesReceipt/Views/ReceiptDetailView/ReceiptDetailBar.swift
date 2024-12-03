//
//  ReceiptDetailBar.swift
//  SalesReceipt
//
//  Created by Quasar on 04.12.2024.
//

import SwiftUI

struct ReceiptDetailBar: View {
    var title: String
    var isPDFCreated: Bool
    var onGeneratePDF: () -> Void
    var actionBack: () -> Void

    var body: some View {
        HStack {
            Button(action: actionBack) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(BorderlessButtonStyle())

            Text(title)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)

            Button(action: {
                if !isPDFCreated {
                    onGeneratePDF()
                }
            }) {
                Text("PDF")
                    .font(.subheadline)
                    .frame(width: 45, height: 45)
                    .foregroundColor(isPDFCreated ? .gray : .black)
                    .innerStroke(lineWidth: isPDFCreated ? 1 : 2, color: isPDFCreated ? .gray : .black)
            }
            .buttonStyle(BounceButtonStyle())
            .disabled(isPDFCreated)
        }
        .padding(.horizontal, 10)
        .frame(height: 50)
    }
}

//struct ReceiptDetailBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ReceiptDetailBar()
//    }
//}
