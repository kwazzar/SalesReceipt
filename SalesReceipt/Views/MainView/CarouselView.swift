//
//  CarouselView.swift
//  SalesReceipt
//
//  Created by Quasar on 08.11.2024.
//

import SwiftUI

struct CarouselView: View {
    @StateObject var viewModel: SalesViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(viewModel.filteredItems, id: \.description) { item in
                    ItemButton(item: item) {
                        viewModel.addItem(item)
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
        .innerStroke()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

//struct CarouselView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = SalesViewModel()
//
//        return CarouselView(viewModel: viewModel)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
