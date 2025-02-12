//
//  DailySalesFactory.swift
//  SalesReceipt
//
//  Created by Quasar on 29.01.2025.
//

import Foundation

protocol DailySalesFactory {
    func createDailySalesViewModel() -> DailySalesViewModel
    func createDailySalesView() -> DailySalesView
}
