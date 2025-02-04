//
//  SalesFactory.swift
//  SalesReceipt
//
//  Created by Quasar on 29.01.2025.
//

import Foundation

protocol SalesFactory {
    func createSalesViewModel() -> SalesViewModel
    func createSalesView() -> SalesView
}
