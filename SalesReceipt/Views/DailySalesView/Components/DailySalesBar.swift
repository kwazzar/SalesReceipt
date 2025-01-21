//
//  DailySalesBar.swift
//  SalesReceipt
//
//  Created by Quasar on 04.12.2024.
//

import SwiftUI

struct DailySalesHeader: View {
    var title: String
    var onDismiss: () -> Void
    var onFilterToggle: () -> Void
    var onDeleteRequest: () -> Void

    var body: some View {
        ZStack {
            HStack {
                Button(action: onDismiss) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(BorderlessButtonStyle())

                Spacer()

                Button(action: onFilterToggle) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(BorderlessButtonStyle())

                Button(action: onDeleteRequest) {
                    Image(systemName: "trash")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(BorderlessButtonStyle())
            }

            Text(title)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .frame(height: 50)
    }
}

//struct DailySalesBar_Previews: PreviewProvider {
//    static var previews: some View {
//        DailySalesBar()
//    }
//}
