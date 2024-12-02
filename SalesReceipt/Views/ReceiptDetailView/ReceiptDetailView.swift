//
//  ReceiptDetailView.swift
//  SalesReceipt
//
//  Created by Quasar on 13.11.2024.
//

import SwiftUI

struct ReceiptDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ReceiptDetailViewModel
    @State private var isShareButtonVisible = false

    var body: some View {
        VStack {
            DetailBar(title: "ReceiptDetail", isPDFCreated: viewModel.pdfUrlReceipt != nil) {
                viewModel.generatePDF()
            }
            actionBack: {
                presentationMode.wrappedValue.dismiss()
            }

            if let pdfUrlReceipt = viewModel.pdfUrlReceipt {
                withAnimation(.easeInOut(duration: 0.5)) {
                    sharePdfButton(pdfUrlReceipt)
                }
            } else {
                Text("PDF not created yet")
                    .foregroundColor(.gray)
            }

            DetailSalesReceipt(viewModel.receipt)
            Spacer()
        }
        .onChange(of: viewModel.pdfUrlReceipt) { newValue in
            withAnimation {
                isShareButtonVisible = newValue != nil
                viewModel.isPdfCreated = newValue != nil
                print("🔄 PDF URL Changed: \(newValue != nil)")
            }
        }
        .onAppear {
            print("📱 View Appeared for Receipt ID: \(viewModel.receipt.id)")
            let pdfExists = viewModel.checkPDFExists()
            print("🕵️ PDF Exists on Appear: \(pdfExists)")
            isShareButtonVisible = pdfExists

            if pdfExists {
                viewModel.generatePDF()
            }
        }
    }

    private func sharePdfButton(_ url: PdfUrlReceipt) -> some View {
        Button(action: {
            viewModel.sharePDF(pdfUrl: url)
        }) {
            Text("Share PDF")
                .frame(maxWidth: .infinity)
                .font(.custom("New York", size: 20))
                .foregroundColor(.black)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .innerStroke(cornerRadius: 8, lineWidth: 2, color: .black, inset: 4)
                .padding(.horizontal, 20)
                .opacity(isShareButtonVisible ? 1 : 0)
                .scaleEffect(isShareButtonVisible ? 1 : 0.8)
        }
        .buttonStyle(BounceButtonStyle())
    }
}

//MARK: - ReceiptDetailBar
struct DetailBar: View {
    var title: String
    var isPDFCreated: Bool
    var onGeneratePDF: () -> Void
    var actionBack: () -> Void
    
    var body: some View {
        HStack {
            Button(action: actionBack) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Text(title)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)
            
            Button(action: {
                if !isPDFCreated {
                    onGeneratePDF()
                }
            }) {
                Text("PDF")
                    .font(.subheadline)
                    .frame(width: 45, height: 45)
                    .foregroundColor(isPDFCreated ? .gray : .black)
                    .innerStroke(lineWidth: isPDFCreated ? 1 : 2, color: isPDFCreated ? .gray : .black)
            }
            .buttonStyle(BounceButtonStyle())
            .disabled(isPDFCreated)
        }
        .padding(.horizontal, 10)
        .frame(height: 50)
    }
}

struct ReceiptDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Mock Receipt
        let mockReceipt = Receipt(
            id: UUID(),
            date: Date(), customerName: CustomerName("John Doe"),
            items: [
                Item(id: 1, description: "T-Shirt", price: Price(25.0), image: ImageItem("tshirt")),
                Item(id: 2, description: "Jeans", price: Price(50.0), image: ImageItem("jeans")),
                Item(id: 3, description: "Sneakers", price: Price(25.0), image: ImageItem("sneakers"))
            ]
        )
        // Pass the mock data to the ReceiptDetailView
        //        ReceiptDetailView(receipt: mockReceipt)
        ReceiptDetailView(viewModel: ReceiptDetailViewModel(receipt: mockReceipt, pdfGenerator: PDFGenerator()))
    }
}
