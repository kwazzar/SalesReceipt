//
//  CustomDatePickerView.swift
//  SalesReceipt
//
//  Created by Quasar on 04.12.2024.
//

import SwiftUI

struct CustomDatePickerView: View {
    let title: String
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .padding(6)
                .background(Color.white)
                .cornerRadius(8)
                .innerStroke(cornerRadius: 10, lineWidth: 2, color: .black, inset: 6)
        }
        .padding(.horizontal, 10)
    }
}

//struct CustomDatePickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomDatePickerView()
//    }
//}
