//
//  CarouselView.swift
//  SalesReceipt
//
//  Created by Quasar on 08.11.2024.
//

import SwiftUI

struct CarouselView: View {
    var items: [Item]
    let actionItem: (Item) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(items, id: \.description) { item in
                    ItemButton(item: item) {
                        actionItem(item)
                    }
                    .frame(width: 150, height: 200)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 220)
    }
}

//MARK: - ItemButton
struct ItemButton: View {
    let item: Item
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: item.image.value)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                Text(item.description.value)
                    .foregroundColor(.black)
                Text(String(format: "%.2f $", item.price.value))
                    .foregroundColor(.black)
            }
        }
        .padding()
        .innerStroke(cornerRadius: 16)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(16)
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView(items: mockItems, actionItem: {_ in })
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
