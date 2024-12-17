//
//  BottomSheet.swift
//  SalesReceipt
//
//  Created by Quasar on 13.12.2024.
//

import SwiftUI

enum BottomSheetState {
    case closed
    case overall
    case expanded
    
    var offset: CGFloat {
        switch self {
        case .closed:
            return UIScreen.main.bounds.height * 0.88
        case .overall:
            return UIScreen.main.bounds.height * 0.72
        case .expanded:
#warning("настроить висоту чтоби было видно пикер")
            return UIScreen.main.bounds.height * 0.1
        }
    }
}

struct BottomSheetView<Content: View>: View {
    @Binding var state: BottomSheetState
    @GestureState private var dragOffset: CGFloat = 0
    
    let content: Content
    
    init(state: Binding<BottomSheetState>, @ViewBuilder content: () -> Content) {
        self._state = state
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    content
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height - state.offset, alignment: .top)
                        .background(Color(.systemBackground))
                }
                Spacer()
            }
            .clipShape(
                state == .expanded ? AnyShape(Rectangle()) : AnyShape(CustomTopRoundedShape())
            )
            .shadow(radius: 10)
            .offset(y: state.offset + dragOffset)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        withAnimation {
                            let threshold = geometry.size.height * 0.2
                            if value.translation.height < -threshold {
                                state = state == .closed ? .overall : .expanded
                            } else if value.translation.height > threshold {
                                state = state == .expanded ? .overall : .closed
                            }
                        }
                    }
            )
            .onTapGesture(count: 1) {
                withAnimation {
                    state = state == .closed ? .overall : .expanded
                }
            }
            .onTapGesture(count: 2) {
                withAnimation {
                    state = .expanded
                }
            }
            .scrollDisabled(state != .expanded)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}