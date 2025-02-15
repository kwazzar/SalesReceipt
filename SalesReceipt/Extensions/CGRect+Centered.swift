//
//  CGRect+Centered.swift
//  SalesReceipt
//
//  Created by Quasar on 25.01.2025.
//

import CoreFoundation

extension CGRect {
    var centered: CGRect {
        CGRect(x: midX, y: midY, width: 0, height: 0)
    }
}
