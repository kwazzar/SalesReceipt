//
//  Extension + View.swift
//  SalesReceipt
//
//  Created by Quasar on 05.11.2024.
//

import SwiftUI
import PopupView

extension View {
    func innerStroke(cornerRadius: CGFloat = 8, lineWidth: CGFloat = 2, color: Color = .black, inset: CGFloat = 4) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .inset(by: inset)
                .stroke(color, lineWidth: lineWidth)
        )
    }
    
    func configurePopup<PopupContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> PopupContent
    ) -> some View {
        self.popup(isPresented: isPresented) {
            content()
        } customize: {
            $0
                .type(.toast)
                .position(.top)
                .animation(.easeInOut)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        }
    }
}
