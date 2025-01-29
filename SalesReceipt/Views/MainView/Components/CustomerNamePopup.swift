//
//  CustomerNamePopup.swift
//  SalesReceipt
//
//  Created by Quasar on 03.12.2024.
//

import SwiftUI

struct CustomerNamePopup: View {
    @Binding var inputName: String
    let anonymousButton: () -> Void
    let saveNameButton: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: onBack) {
                    ZStack {
                        Circle()
                            .stroke(Color.black, lineWidth: 3)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                Spacer()
                
                Text("Enter Customer Name")
                    .font(.headline)
                Spacer()
            }
            
            TextField("Full name", text: $inputName)
                .textFieldStyle(.roundedBorder)
                .frame(height: 45)
                .background(Color.gray.opacity(0.1))
                .innerStroke(inset: 1)
                .padding(5)
            
            HStack {
                Button("Anonymous") {
                    anonymousButton()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .padding()
                .background(Color.red.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(8)
                .innerStroke(inset: 1)
                Spacer()
                
                Button("Save Name") {
                    saveNameButton()
                    inputName = ""
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .padding()
                .background(Color.clear.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(8)
                .innerStroke(inset: 1)
            }
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 8)
        .innerStroke(inset: 1)
    }
}

struct CustomerNamePopup_Previews: PreviewProvider {
    static var previews: some View {
        CustomerNamePopup(
            inputName: .constant(""),
            anonymousButton: {},
            saveNameButton: {},
            onBack: {}
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
