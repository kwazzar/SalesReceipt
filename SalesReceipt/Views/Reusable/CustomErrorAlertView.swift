//
//  CustomErrorAlertView.swift
//  SalesReceipt
//
//  Created by Quasar on 26.01.2025.
//

import SwiftUI

struct CustomErrorAlertView: View {
    let title: String
    let message: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    let primaryAction: () -> Void
    let dismissAction: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)

                Text(message)
                    .font(.body)
                    .multilineTextAlignment(.center)

                HStack(spacing: 12) {
                    Button(action: dismissAction) {
                        Text(secondaryButtonTitle)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }.innerStroke(cornerRadius: 12,
                                  lineWidth: 2,
                                  color: .black,
                                  inset: 1)

                    Button(action: primaryAction) {
                        Text(primaryButtonTitle)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    .innerStroke(cornerRadius: 12,
                                 lineWidth: 2,
                                 color: .black,
                                 inset: 1)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .innerStroke(cornerRadius: 12,
                         lineWidth: 2,
                         color: .black,
                         inset: 1)
            .padding(24)
        }
    }
}
