//
//  BottomBar.swift
//  SalesReceipt
//
//  Created by Quasar on 04.11.2024.
//

import SwiftUI
struct BottomBar: View {
    @StateObject var viewModel: SalesViewModel
    @ObservedObject private var uiState: SalesUIState

    init(viewModel: SalesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.uiState = viewModel.uiState
    }

    var body: some View {
        VStack {
            HStack {
                ForEach(BottomBarButtonType.allCases, id: \.self) { button in
                    BottomBarButton(buttonType: button, viewModel: viewModel)
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
            uiState.showingDailySales.toggle()
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
                    get: { uiState.showingDailySales },
                    set: { uiState.showingDailySales = $0 }
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
    @StateObject var viewModel: SalesViewModel
    
    var body: some View {
        Button(action: {
            buttonType.action(viewModel: viewModel)
        }) {
            Text(buttonType.title)
                .font(.custom("New York", size: 20))
                .frame(width: 150,  height: 40)
                .padding(10)
                .background(Color(.systemGray6))
                .foregroundColor(.black)
                .cornerRadius(12)
                .innerStroke(cornerRadius: 8, lineWidth: 2, color: .black, inset: 4)
                .opacity(viewModel.currentItems.isEmpty && buttonType == .checkout ? 0.5 : 1.0)
        }
        .buttonStyle(BounceButtonStyle())
        .disabled(buttonType == .checkout && viewModel.currentItems.isEmpty)
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
