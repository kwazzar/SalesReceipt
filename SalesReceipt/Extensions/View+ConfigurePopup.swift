//
//  View+ConfigurePopup.swift
//  SalesReceipt
//
//  Created by Quasar on 15.02.2025.
//

import SwiftUI
import PopupView

extension View {
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
