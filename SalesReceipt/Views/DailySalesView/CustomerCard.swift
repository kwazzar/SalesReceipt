//
//  CustomerCard.swift
//  SalesReceipt
//
//  Created by Quasar on 06.11.2024.
//

import SwiftUI

struct CustomerCard: View {
    let id: UUID
    let name: String
    let date: Date
    let total: Double
    let items: Int
    let infoAction: () -> Void
    let deleteAction: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        Button(action: infoAction) {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.black)
                                Text("Info")
                                    .foregroundColor(.black)
                            }
                            .frame(width: 90, height: 45)
                            .innerStroke()
                        }
                        .buttonStyle(BounceButtonStyle())
                        Spacer()
                        
                        Text("\(id.uuidString)")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .lineLimit(1)
                            .padding(.bottom, 2)
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(name)")
                                .font(.headline)
                                .lineLimit(1)
                            Text("\(String(format: "%.2f $", total))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("number of items: \(items)")
                            Text("\(date, formatter: itemFormatter)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(14)
            .innerStroke(cornerRadius: 14, lineWidth: 2, color: .black, inset: 1)
        }
        .contextMenu {
            Button(role: .destructive, action: deleteAction) {
                Label("Delete Receipt", systemImage: "trash")
            }
        }
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

//struct CustomerCard_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomerCard(id: UUID(), name: "Customer", date: Date(), total: 1.11, items: 27)
//    }
//}
