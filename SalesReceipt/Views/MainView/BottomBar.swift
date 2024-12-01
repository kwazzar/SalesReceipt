//
//  BottomBar.swift
//  SalesReceipt
//
//  Created by Quasar on 04.11.2024.
//

import SwiftUI

struct BottomBar: View {
    @StateObject var viewModel: SalesViewModel

    var body: some View {
        VStack {
            HStack {
                ForEach(TypeButton.allCases, id: \.self) { button in
                    BottomBarButton(buttonType: button, viewModel: viewModel)
                        .frame(maxWidth: .infinity)
                        .layoutPriority(1)
                }
                .padding(.horizontal, 2)
            }
            salesForDayButton()
        }
    }

    private func salesForDayButton() -> some View {
        Button(action: {
            viewModel.showingDailySales.toggle()
        }) {
            Text("Sales for Day")
                .frame(maxWidth: .infinity)
                .font(.custom("New York", size: 20))
                .foregroundColor(.black)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .innerStroke(cornerRadius: 8, lineWidth: 2, color: .black, inset: 4)
                .padding(.horizontal, 20)
                .fullScreenCover(isPresented: $viewModel.showingDailySales) {
                    DailySalesView()
                }
        }.buttonStyle(BounceButtonStyle())
    }
}

//MARK: - BottomBarButton
struct BottomBarButton: View {
    var buttonType: TypeButton
    @StateObject var viewModel: SalesViewModel

    var body: some View {
        Button(action: {
            buttonType.action(viewModel: viewModel)
        }) {
            Text(buttonType.title)
                .font(.custom("New York", size: 20))
                .frame(height: 48)
                .padding(10) // Відступ для тексту, щоб обведення було всередині
                .background(Color(.systemGray6))
                .foregroundColor(.black)
                .cornerRadius(12) // Збільшений радіус фону для кнопки
                .innerStroke(cornerRadius: 8, lineWidth: 2, color: .black, inset: 4)
                .opacity(viewModel.currentItems.isEmpty && buttonType == .checkout ? 0.5 : 1.0)
        }
        .buttonStyle(BounceButtonStyle())
        .disabled(buttonType == .checkout && viewModel.currentItems.isEmpty)
    }
}

//MARK: - TypeButton
enum TypeButton: String, CaseIterable {
    case removeLast
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
        case .removeLast:
            return Color.clear
        case .clearAll:
            return Color.clear
        case .checkout:
            return Color.clear
        }
    }

    func action(viewModel: SalesViewModel) {
        switch self {
        case .removeLast:
            viewModel.removeLastItem()
        case .clearAll:
            viewModel.clearAll()
        case .checkout:
            viewModel.checkout()
        }
    }
}