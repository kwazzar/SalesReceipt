//
//  DateRangePicker.swift
//  SalesReceipt
//
//  Created by Quasar on 18.01.2025.
//

import SwiftUI

struct DateRangePicker: View {
    @Binding var startDate: Date
    @Binding var endDate: Date

    var body: some View {
        HStack(spacing: 3) {
            CustomDatePickerView(title: "Start", selectedDate: $startDate)
                .onChange(of: startDate) { newStartDate in
                    if endDate < newStartDate {
                        endDate = newStartDate
                    }
                }

            CustomDatePickerView(title: "End", selectedDate: $endDate)
                .onChange(of: endDate) { newEndDate in
                    if newEndDate < startDate {
                        endDate = startDate
                    }
                }
        }
        .padding(-5)
    }
}
