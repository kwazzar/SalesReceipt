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
   private let factory: CoordinatorFactory

   init(factory: CoordinatorFactory) {
       self.factory = factory
   }

   @ViewBuilder
   func view() -> some View {
       ZStack {
           switch navigationState {
           case .sales:
               factory.createSalesView()
                   .environmentObject(self)
                   .transition(.asymmetric(
                       insertion: .move(edge: .leading).combined(with: .opacity),
                       removal: .move(edge: .leading).combined(with: .opacity)
                   ))
           case .dailySales:
               factory.createDailySalesView()
                   .environmentObject(self)
                   .transition(.asymmetric(
                       insertion: .move(edge: .trailing).combined(with: .opacity),
                       removal: .move(edge: .trailing).combined(with: .opacity)
                   ))
           case .receiptDetail(let receipt):
               factory.createReceiptDetailView(receipt: receipt)
                   .environmentObject(self)
                   .transition(.asymmetric(
                       insertion: .move(edge: .bottom).combined(with: .opacity),
                       removal: .move(edge: .bottom).combined(with: .opacity)
                   ))
           }
       }
       .animation(.spring(response: 0.3, dampingFraction: 0.8), value: navigationState)
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
