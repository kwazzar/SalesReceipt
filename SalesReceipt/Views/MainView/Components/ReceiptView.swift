//
//  ReceiptView.swift
//  SalesReceipt
//
//  Created by Quasar on 08.11.2024.
//

import SwiftUI

struct ReceiptView: View {
    let items: [Item]
    let total: Double
    @ObservedObject var uiState: SalesUIState
    let onDeleteItem: (Item) -> Void
    let onDecrementItem: (Item) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Receipt")
                .font(.system(size: 24, weight: .medium))
                .padding(.top, 20)
            
            CustomDivider()
                .padding(.vertical, 15)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(items, id: \.id) { item in
                        HStack {
                            if item.quantity > 1 {
                                Text("\(item.quantity)x")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                    .frame(width: 35, alignment: .leading)
                            }
                            
                            Text(item.description.value)
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            Text("$\(String(format: "%.2f", item.price.value * Double(item.quantity)))")
                                .font(.system(size: 16, weight: .medium))
                            
                            ItemActionButton(
                                item: item,
                                uiState: uiState,
                                onDelete: onDeleteItem,
                                onDecrement: onDecrementItem
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .frame(maxHeight: 300)
            .onTapGesture {
                if uiState.activeMenuItemID != nil {
                    withAnimation {
                        uiState.activeMenuItemID = nil
                    }
                }
            }
            
            CustomDivider()
                .padding(.vertical, 15)
            
            HStack {
                Text("Total")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                Text("$\(String(format: "%.2f", total))")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
        .innerStroke(cornerRadius: 16, lineWidth: 2, inset: 1)
        .padding(.horizontal, 16)
    }
}

// MARK: - ItemActionButton
struct ItemActionButton: View {
    let item: Item
    @ObservedObject var uiState: SalesUIState
    let onDelete: (Item) -> Void
    let onDecrement: (Item) -> Void
    
    var isActive: Bool {
        uiState.activeMenuItemID == item.id
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            if !isActive {
                Button(action: {
                    withAnimation {
                        uiState.activeMenuItemID = item.id
                    }
                }) {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .frame(width: 44, height: 44)
                }
                .opacity(uiState.activeMenuItemID == nil ? 1 : 0)
            }
            
            if isActive {
                VStack(spacing: 8) {
                    Button(action: {
                        onDelete(item)
                        withAnimation {
                            uiState.activeMenuItemID = nil
                        }
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        )
                    }
                    
                    Button(action: {
                        onDecrement(item)
                        withAnimation {
                            uiState.activeMenuItemID = nil
                        }
                    }) {
                        HStack {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        )
                    }
                }
                .transition(.scale(scale: 0.9, anchor: .topTrailing))
                .padding(.top, 44)
            }
        }
        .frame(width: 44, height: 44)
    }
}

//MARK: - CustomDivider
struct CustomDivider: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 20, y: 0))
                path.addLine(to: CGPoint(x: geometry.size.width - 20, y: 0))
            }
            .stroke(style: StrokeStyle(
                lineWidth: 1,
                dash: [4]
            ))
            .foregroundColor(.black.opacity(0.3))
        }
        .frame(height: 1)
    }
}

struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        
        let sampleItems = [
            Item(description: Description("Product A"),
                 price: Price(9.99),
                 image: ImageItem("cart")),
            Item(description: Description("Product B"),
                 price: Price(5.49),
                 image: ImageItem("bag")),
            Item(description: Description("Product C"),
                 price: Price(12.75),
                 image: ImageItem("gift"))
        ]
        
        let total = sampleItems.reduce(0) { $0 + $1.price.value }
        let uiState = SalesUIState()
        
        return ReceiptView(
            items: sampleItems,
            total: total,
            uiState: uiState,
            onDeleteItem: { _ in },
            onDecrementItem: { _ in }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
