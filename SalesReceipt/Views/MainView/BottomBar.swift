//
//  BottomBar.swift
//  SalesReceipt
//
//  Created by Quasar on 04.11.2024.
//

import SwiftUI
struct BottomBar: View {
    @Binding var showingDailySales: Bool
    var clearAllAction: () -> Void
    var checkoutAction: () -> Void
    var isCheckoutDisabled: Bool

    var body: some View {
        VStack {
            HStack {
                ForEach(BottomBarButtonType.allCases, id: \.self) { button in
                    BottomBarButton(buttonType: button,
                                    action: {
                        switch button {
                        case .clearAll:
                            clearAllAction()
                        case .checkout:
                            checkoutAction()
                        }
                    },
                                    isDisabled: button == .checkout && isCheckoutDisabled,
                                    opacity: button == .checkout && isCheckoutDisabled ? 0.5 : 1.0)
                    .frame(maxWidth: .infinity)
                    .layoutPriority(1)
                }
                .padding(.horizontal, 2)
            }
            salesButton()
        }
    }

    private func salesButton() -> some View {
        Button(action: {
            showingDailySales.toggle()
        }) {
            Text("Daily Sales")
                .frame(maxWidth: .infinity)
                .font(.custom("New York", size: 20))
                .foregroundColor(.black)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .innerStroke(cornerRadius: 8, lineWidth: 2, color: .black, inset: 4)
                .padding(.horizontal, 20)
                .fullScreenCover(isPresented: Binding(
                    get: { showingDailySales },
                    set: { showingDailySales = $0 }
                )) {
                    DailySalesView(viewModel: DailySalesViewModel(
                        receiptManager: ReceiptManager(database: SalesDatabase.shared),
                        statisticsService: StatisticsManager()
                    ))
                }
        }.buttonStyle(BounceButtonStyle())
    }
}

//MARK: - BottomBarButton
struct BottomBarButton: View {
    var buttonType: BottomBarButtonType
    var action: () -> Void
    var isDisabled: Bool
    var opacity: Double
    
    var body: some View {
        Button(action: action) {
            Text(buttonType.title)
                .font(.custom("New York", size: 20))
                .frame(width: 150,  height: 40)
                .padding(10)
                .background(Color(.systemGray6))
                .foregroundColor(.black)
                .cornerRadius(12)
                .innerStroke(cornerRadius: 8, lineWidth: 2, color: .black, inset: 4)
                .opacity(opacity)
            //                .opacity(viewModel.currentItems.isEmpty && buttonType == .checkout ? 0.5 : 1.0)
#warning("opacity -")
        }
        .buttonStyle(BounceButtonStyle())
        .disabled(isDisabled)
        //        .disabled(buttonType == .checkout && viewModel.currentItems.isEmpty)
#warning("disabled -")
    }
}

//MARK: - BottomBarButtonType
enum BottomBarButtonType: String, CaseIterable {
    case clearAll
    case checkout
    
    var title: String {
        rawValue
            .enumerated()
            .map { index, char in
                index > 0 && char.isUppercase ? " \(char)" : "\(char)"
            }
            .joined()
            .capitalized
    }
    
    var buttonColor: Color {
        switch self {
        case .clearAll:
            return Color.clear
        case .checkout:
            return Color.clear
        }
    }
    
    func action(viewModel: SalesViewModel) {
        switch self {
        case .clearAll:
            viewModel.clearAll()
        case .checkout:
            viewModel.checkout()
        }
    }
}
