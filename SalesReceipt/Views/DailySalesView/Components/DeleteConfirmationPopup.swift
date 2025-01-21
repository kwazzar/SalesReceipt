//
//  DeleteConfirmationPopup.swift
//  SalesReceipt
//
//  Created by Quasar on 18.01.2025.
//

import SwiftUI

struct DeleteConfirmationPopup: View {
    @Binding var isPresented: Bool
    var onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Delete All Receipts")
                .font(.headline)
            Text("Are you sure you want to delete all receipts? This action cannot be undone.")
                .font(.subheadline)
                .multilineTextAlignment(.center)

            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .innerStroke(inset: 1)
                }

                Button(action: {
                    onConfirm()
                    isPresented = false
                }) {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .innerStroke(inset: 1)
                }
            }
        }
        .padding()
        .innerStroke(cornerRadius: 12, lineWidth: 2, color: .black, inset: 1)
        .background(Color.white)
        .cornerRadius(12)
        .padding(40)
        .offset(y: 40)
    }
}
