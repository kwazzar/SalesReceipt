//
//  MainCoordinator.swift
//  SalesReceipt
//
//  Created by Quasar on 05.02.2025.
//

import SwiftUI

final class MainCoordinator: ObservableObject {
    @Published private(set) var navigationState: Route = .sales
    @Published private var screenStack: [Route] = [.sales]

    let makeSalesView: () -> SalesView
    let makeDailySalesView: () -> DailySalesView
    let makeReceiptDetailView: (Receipt) -> ReceiptDetailView

    init(
        makeSalesView: @escaping () -> SalesView,
        makeDailySalesView: @escaping () -> DailySalesView,
        makeReceiptDetailView: @escaping (Receipt) -> ReceiptDetailView
    ) {
        self.makeSalesView = makeSalesView
        self.makeDailySalesView = makeDailySalesView
        self.makeReceiptDetailView = makeReceiptDetailView
    }

    @ViewBuilder
    func view() -> some View {
        ZStack {
            switch navigationState {
            case .sales:
                makeSalesView()
                    .environmentObject(self)
                    .customTransition(direction: .leading)
            case .dailySales:
                makeDailySalesView()
                    .environmentObject(self)
                    .customTransition(direction: .trailing)
            case .receiptDetail(let receipt):
                makeReceiptDetailView(receipt)
                    .environmentObject(self)
                    .customTransition(direction: .bottom)
            }
        }
        .animation(
            .spring(response: 0.4, dampingFraction: 0.85, blendDuration: 0.3),
            value: navigationState
        )
    }

    func navigateTo(_ route: Route) {
        screenStack.append(route)
        navigationState = route
    }

    func dismiss() {
        screenStack.removeLast()
        navigationState = screenStack.last ?? .sales
    }

    func popToRoot() {
        screenStack = [.sales]
        navigationState = .sales
    }
}
