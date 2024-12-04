//
//  CustomerNamePopup.swift
//  SalesReceipt
//
//  Created by Quasar on 03.12.2024.
//

import SwiftUI

#warning("якщо швидко натискати через кнопки попапа робиться два чека")
struct CustomerNamePopup: View {
    @StateObject var viewModel: SalesViewModel
    @State private var inputName: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Customer Name")
                .font(.headline)

            TextField("Full name", text: $inputName)
                .textFieldStyle(.roundedBorder)
                .frame(height: 45)
                .background(Color.gray.opacity(0.1))
                .innerStroke(inset: 1)
                .padding(5)

            HStack {
                Button("Anonymous") {
                    viewModel.finalizeCheckout(with: "")
                    viewModel.isPopupVisible = false
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .padding()
                .background(Color.red.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(8)
                .innerStroke(inset: 1)
                Spacer()

                Button("Save Name") {
                    viewModel.finalizeCheckout(with: inputName)
                    viewModel.isPopupVisible = false
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .padding()
                .background(Color.clear.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(8)
                .innerStroke(inset: 1)
            }
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 8)
        .innerStroke(inset: 1)
    }
}

struct CustomerNamePopup_Previews: PreviewProvider {
    static var previews: some View {
        CustomerNamePopup(viewModel: SalesViewModel(ReceiptManager(database: SalesDatabase.shared)))
    }
}
