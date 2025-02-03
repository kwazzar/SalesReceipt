//
//  SalesChartView.swift
//  SalesReceipt
//
//  Created by Quasar on 10.12.2024.
//

import SwiftUI
import Charts

struct SalesChartView: View {
    private let salesStats: [DailySales]
    @State private var showChart = false

    init(_ salesStats: [DailySales]) {
        self.salesStats = salesStats
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            chartTitle

            if !salesStats.isEmpty {
                if showChart {
                    chartContent
                    monthLabels
                } else {
                    ProgressView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    showChart = true
                                }
                            }
                        }
                }
            } else {
                noDataView
            }
        }
    }
}

//MARK: - Extension
extension SalesChartView {
    private var chartTitle: some View {
        Text("Sales Dynamics")
            .font(.headline)
            .padding(.horizontal)
    }

    private var chartContent: some View {
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
                    Gradient(colors: [.white.opacity(0.4), .blue])
                )
                .cornerRadius(8)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(date, format: .dateTime.day().month())
                            .lineLimit(1)
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
        .innerStroke(inset: 2)
        .background(chartBackground)
        .padding(.horizontal)
    }

    private var chartBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.45),
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
    }

    private var monthLabels: some View {
        HStack {
            ForEach(salesStats.prefix(12), id: \.date) { stat in
                Text(stat.date, format: .dateTime.month(.abbreviated))
                    .font(.caption)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
    }

    private var noDataView: some View {
        Text("No data available for display.")
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}

struct SalesChartView_Previews: PreviewProvider {
    static var previews: some View {
        SalesChartView([
            DailySales(date: Date().addingTimeInterval(-86400), totalAmount: 500.0, itemCount: 25),
            DailySales(date: Date(), totalAmount: 235.0, itemCount: 25)
        ])
    }
}
