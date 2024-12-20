//
//  SalesChartView.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import SwiftUI
import Charts

#warning("better statistics chart")
struct SalesChartView: View {
    private let salesStats: [SalesStat]
    
    init(_ salesStats: [SalesStat]) {
        self.salesStats = salesStats
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sales Dynamics")
                .font(.headline)
                .padding(.horizontal)
            
            if !salesStats.isEmpty {
                Chart {
                    ForEach(salesStats) { stat in
                        BarMark(
                            x: .value("Date", stat.date, unit: .day),
                            y: .value("Amount", stat.totalAmount)
                        )
                        .annotation(position: .top) {
                            Text(String(format: "%.2f ₴", stat.totalAmount))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .annotation(position: .overlay) {
                            Text(stat.date, format: .dateTime.day())
                                .font(.caption2)
                                .foregroundColor(.primary)
                        }
                        .foregroundStyle(
                            Gradient(colors: [.blue.opacity(0.6), .blue])
                        )
                        .cornerRadius(4)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(date, format: .dateTime.day().month())
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel {
                            if let amount = value.as(Double.self) {
                                Text(String(format: "%.0f ₴", amount))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .frame(height: 300)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue.opacity(0.15),
                                    Color.blue.opacity(0.05)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal)
                
                // Підпис під графіком із назвами місяців
                HStack {
                    ForEach(salesStats.prefix(12), id: \.date) { stat in
                        Text(stat.date, format: .dateTime.month(.abbreviated))
                            .font(.caption)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
            } else {
                Text("No data available for display.")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
    }
}

//struct SalesChartView: View {
//    private let salesStats: [SalesStat]
//
//    init(_ salesStats: [SalesStat]) {
//        self.salesStats = salesStats
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Sales Dynamics")
//                .font(.headline)
//                .padding(.horizontal)
//
//            if !salesStats.isEmpty {
//                Chart {
//                    ForEach(salesStats) { stat in
//                        BarMark(
//                            x: .value("Date", stat.date, unit: .day),
//                            y: .value("Amount", stat.totalAmount)
//                        )
//                        .annotation(position: .top) {
//                            Text(String(format: "%.2f ₴", stat.totalAmount))
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                        .annotation(position: .overlay) {
//                            Text(stat.date, format: .dateTime.day())
//                                .font(.caption2)
//                                .foregroundColor(.primary)
//                        }
//                        .foregroundStyle(
//                            Gradient(colors: [.white.opacity(0.7), .blue])
//                        )
//                        .cornerRadius(4)
//                    }
//                }
//                .chartXAxis {
//                    AxisMarks(values: .automatic) { value in
//                        AxisValueLabel {
//                            if let date = value.as(Date.self) {
//                                Text(date, format: .dateTime.day().month())
//                            }
//                        }
//                    }
//                }
//                .chartYAxis {
//                    AxisMarks(values: .automatic) { value in
//                        AxisValueLabel {
//                            if let amount = value.as(Double.self) {
//                                Text(String(format: "%.0f ₴", amount))
//                            }
//                        }
//                    }
//                }
//                .frame(height: 300)
//                .padding(.horizontal)
//                .background(
//                    RoundedRectangle(cornerRadius: 16)
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.blue.opacity(0.05)]),
//                                startPoint: .top,
//                                endPoint: .bottom
//                            )
//                        )
//                        .innerStroke(inset: 1)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 16)
//                                .stroke(Color.blue.opacity(0.5), lineWidth: 1)
//                        )
//                )
//                .padding(.horizontal)
//
//            } else {
//                Text("No data available for display.")
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//                    .padding(.horizontal)
//            }
//        }
//    }
//}

struct SalesChartView_Previews: PreviewProvider {
    static var previews: some View {
        SalesChartView([
            SalesStat(date: Date().addingTimeInterval(-86400), totalAmount: 500.0, itemCount: 25),
            SalesStat(date: Date(), totalAmount: 235.0, itemCount: 25)
        ])
    }
}
