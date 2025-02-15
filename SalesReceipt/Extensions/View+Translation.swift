//
//  View+Translation.swift
//  SalesReceipt
//
//  Created by Quasar on 15.02.2025.
//

import SwiftUI

extension View {
    func customTransition(direction: TransitionDirection) -> some View {
        let transition: AnyTransition

        switch direction {
        case .leading:
            transition = .asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        case .trailing:
            transition = .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
        case .bottom:
            transition = .asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            )
        }

        return self.transition(transition)
    }
}

enum TransitionDirection {
    case leading
    case trailing
    case bottom
}
