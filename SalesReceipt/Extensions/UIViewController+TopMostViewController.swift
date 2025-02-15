//
//  UIViewController+TopMostViewController.swift
//  SalesReceipt
//
//  Created by Quasar on 16.01.2025.
//

import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        return self
    }
}
