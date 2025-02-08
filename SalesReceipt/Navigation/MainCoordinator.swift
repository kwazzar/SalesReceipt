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
   private let container: CoordinatorFactory

   init(container: CoordinatorFactory) {
       self.container = container
   }

   @ViewBuilder
   func view() -> some View {
       ZStack {
           switch navigationState {
           case .sales:
               container.createSalesView()
                   .environmentObject(self)
                   .transition(.asymmetric(
                       insertion: .move(edge: .leading)
                           .combined(with: .opacity)
                           .animation(.easeInOut(duration: 0.4)),
                       removal: .move(edge: .leading)
                           .combined(with: .opacity)
                           .animation(.easeInOut(duration: 0.4))
                   ))
           case .dailySales:
               container.createDailySalesView()
                   .environmentObject(self)
                   .transition(.asymmetric(
                       insertion: .move(edge: .trailing)
                           .combined(with: .opacity)
                           .animation(.easeInOut(duration: 0.4)),
                       removal: .move(edge: .trailing)
                           .combined(with: .opacity)
                           .animation(.easeInOut(duration: 0.4))
                   ))
           case .receiptDetail(let receipt):
               container.createReceiptDetailView(receipt: receipt)
                   .environmentObject(self)
                   .transition(.asymmetric(
                       insertion: .move(edge: .bottom)
                           .combined(with: .opacity)
                           .animation(.easeInOut(duration: 0.4)),
                       removal: .move(edge: .bottom)
                           .combined(with: .opacity)
                           .animation(.easeInOut(duration: 0.4))
                   ))
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

   func showDailySales() {
       screenStack.append(.dailySales)
       navigationState = .dailySales
   }

   func showReceiptDetail(receipt: Receipt) {
       screenStack.append(.receiptDetail(receipt))
       navigationState = .receiptDetail(receipt)
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
