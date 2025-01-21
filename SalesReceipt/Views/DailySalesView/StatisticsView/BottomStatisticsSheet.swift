//
//  BottomSheet.swift
//  SalesReceipt
//
//  Created by Quasar on 13.12.2024.
//

import SwiftUI
//MARK: - SheetState
enum BottomSheetState {
    case closed
    case overall
    case expanded
    case withFilters
    
    var offset: CGFloat {
        switch self {
        case .closed:
            return UIScreen.main.bounds.height * 0.88
        case .overall:
            return UIScreen.main.bounds.height * 0.72
        case .expanded:
            return UIScreen.main.bounds.height * 0.06
        case .withFilters:
            return UIScreen.main.bounds.height * 0.165
        }
    }
}

//MARK: - Sheet
struct BottomStatisticsSheet<Content: View>: View {
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
                content
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height - state.offset, alignment: .top)
                    .background(Color(.systemBackground))
                Spacer()
            }
            .clipShape(
                !expandedAndWithFiltersState ? AnyShape(Rectangle()) : AnyShape(CustomTopRoundedShape())
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
                            let currentPosition = state.offset + value.translation.height
                            updateStateBasedOnPosition(currentPosition, geometry: geometry)
                        }
                    }
            )
            .onChange(of: dragOffset) { newOffset in
                let currentPosition = state.offset + newOffset
                if abs(newOffset) > 20 {
                    updateStateBasedOnPosition(currentPosition, geometry: geometry, animated: false)
                }
            }
            .onTapGesture(count: 1) {
                withAnimation {
                    switch state {
                    case .closed:
                        state = .overall
                    case .overall, .withFilters:
                        state = .expanded
                    case .expanded:
                        state = .overall
                    }
                }
            }
            .onTapGesture(count: 2) {
                withAnimation {
                    state = state == .withFilters ? .withFilters : .expanded
                }
            }
            .scrollDisabled(expandedAndWithFiltersState)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

//MARK: - Extension
extension BottomStatisticsSheet {
    private func updateStateBasedOnPosition(_ position: CGFloat, geometry: GeometryProxy, animated: Bool = true) {
        let screenHeight = UIScreen.main.bounds.height
        let closedPosition = screenHeight * 0.88
        let overallPosition = screenHeight * 0.72
        let expandedPosition = screenHeight * 0.06
        
        let newState: BottomSheetState
        
        if position > (closedPosition + overallPosition) / 2 {
            newState = .closed
        } else if position > (overallPosition + expandedPosition) / 2 {
            newState = .overall
        } else {
            newState = .expanded
        }
        
        if animated {
            withAnimation {
                state = newState
            }
        } else {
            state = newState
        }
    }
    
    private var expandedAndWithFiltersState: Bool {
        state != .expanded && state != .withFilters
    }
}
