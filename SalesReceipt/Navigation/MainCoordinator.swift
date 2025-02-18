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
    private let container: CoordinatorContainer

    init(container: CoordinatorContainer) {
        self.container = container
    }

    @ViewBuilder
    func view() -> some View {
        ZStack {
            switch navigationState {
            case .sales:
                container.createSalesView()
                    .environmentObject(self)
                    .customTransition(direction: .leading)
            case .dailySales:
                container.createDailySalesView()
                    .environmentObject(self)
                    .customTransition(direction: .trailing)
            case .receiptDetail(let receipt):
                container.createReceiptDetailView(receipt: receipt)
                    .environmentObject(self)
                    .customTransition(direction: .bottom)
            }
        }
        .animation(
            .spring(
                response: 0.4,
                dampingFraction: 0.85,
                blendDuration: 0.3
            ),
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
