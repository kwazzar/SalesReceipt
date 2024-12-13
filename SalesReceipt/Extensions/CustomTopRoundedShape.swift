//
//  CustomTopRoundedShape.swift
//  SalesReceipt
//
//  Created by Quasar on 13.12.2024.
//

import SwiftUI

struct CustomTopRoundedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: 20)) // Ліва частина вигину
        path.addQuadCurve(to: CGPoint(x: rect.width, y: 20),
                          control: CGPoint(x: rect.width / 2, y: -20)) // Верхній вигин
        path.addLine(to: CGPoint(x: rect.width, y: rect.height)) // Права частина
        path.closeSubpath()
        return path
    }
}
