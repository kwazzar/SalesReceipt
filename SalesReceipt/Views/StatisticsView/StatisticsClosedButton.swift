//
//  StatisticsClosedButton.swift
//  SalesReceipt
//
//  Created by Quasar on 13.12.2024.
//

import SwiftUI

struct StatisticsClosedButton: View {
   private let action: () -> Void

    init(_ action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.clear.opacity(0.8))
                    .frame(width: 44, height: 44)
                Circle()
                    .stroke(Color.black, lineWidth: 3)
                    .frame(width: 44, height: 44)
                Image(systemName: "chevron.down")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }
        .padding(.trailing, 15)
        .buttonStyle(BounceButtonStyle())
        .padding(.top, 18)
    }
}
