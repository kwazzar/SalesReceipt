//
//  StatCard.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

//MARK: - StatType
enum StatType: String, CaseIterable {
    case total
    case itemsSold
    case averageCheck

    var title: String {
        rawValue
            .enumerated()
            .map { index, char in
                index > 0 && char.isUppercase ? " \(char)" : "\(char)"
            }
            .joined()
            .capitalized
    }

    var color: Color {
        switch self {
        case .total:
            return .green
        case .itemsSold:
            return .blue
        case .averageCheck:
            return .orange
        }
    }

    func value(from stats: (total: Double, itemsSold: Int, averageCheck: Double)) -> String {
           switch self {
           case .total:
               return String(format: "%.2f ₴", stats.total)
           case .itemsSold:
               return "\(stats.itemsSold)"
           case .averageCheck:
               return String(format: "%.2f ₴", stats.averageCheck)
           }
       }
}

struct StatRow_Previews: PreviewProvider {
    static var previews: some View {
        StatCard(title: StatType.total.rawValue,
                 value: StatType.total.rawValue,
                 color: .orange)
    }
}
