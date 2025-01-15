//
//  ReceiptDetailView.swift
//  SalesReceipt
//
//  Created by Quasar on 13.11.2024.
//

import SwiftUI

#warning("""
share button bug
""")
struct ReceiptDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ReceiptDetailViewModel
    
    var body: some View {
        VStack {
            ReceiptDetailBar(title: "ReceiptDetail",
                             isPDFCreated: viewModel.pdfUrlReceipt != nil) {
                viewModel.generatePDF()
            }
        actionBack: {
            presentationMode.wrappedValue.dismiss()
        }
            
            if viewModel.pdfUrlReceipt != nil {
                withAnimation(.easeInOut(duration: 0.5)) {
                    sharePdfButton()
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
                viewModel.isShareButtonVisible = newValue != nil
                viewModel.isPdfCreated = newValue != nil
            }
        }
        .onAppear {
            let pdfExists = viewModel.checkPDFExists()
            viewModel.isShareButtonVisible = pdfExists
            if pdfExists {
                viewModel.generatePDF()
            }
        }
    }
    
    private func sharePdfButton() -> some View {
        Button(action: {
            viewModel.sharePDF()
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
                .opacity(viewModel.isShareButtonVisible ? 1 : 0)
                .scaleEffect(viewModel.isShareButtonVisible ? 1 : 0.8)
        }
        .buttonStyle(BounceButtonStyle())
    }
}

struct ReceiptDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Mock Receipt
        let mockReceipt = Receipt(
            id: UUID(),
            date: Date(), customerName: CustomerName("John Doe"),
            items: mockItems
        )
        
        ReceiptDetailView(viewModel: ReceiptDetailViewModel(
            receipt: mockReceipt,
            pdfManager: PDFManager(),
            receiptManager: ReceiptManager(database: SalesDatabase.shared)))
    }
}
