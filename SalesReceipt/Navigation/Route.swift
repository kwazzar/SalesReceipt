//
//  Route.swift
//  SalesReceipt
//
//  Created by Quasar on 05.02.2025.
//

import Foundation

enum Route: Hashable {
    case sales
    case dailySales
    case receiptDetail(Receipt)
}
