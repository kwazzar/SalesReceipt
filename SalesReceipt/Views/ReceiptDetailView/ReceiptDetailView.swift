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
    
    var body: some View {
        ZStack {
            VStack {
                ReceiptDetailBar(title: "ReceiptDetail",
                                 isPDFCreated: viewModel.pdfUrlReceipt != nil) {
                    viewModel.generatePDF()
                }
            actionBack: {
                presentationMode.wrappedValue.dismiss()
            }
                header
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
            alertError
        }
        .animation(.default, value: viewModel.showErrorAlert)
    }
}

//MARK: - Extension
extension ReceiptDetailView {
    @ViewBuilder private var header: some View {
        if viewModel.pdfUrlReceipt != nil {
            withAnimation(.easeInOut(duration: 0.5)) {
                sharePdfButton
            }
        } else {
            Text("PDF not created yet")
                .foregroundColor(.gray)
        }

    }

    private var sharePdfButton: some View {
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

    @ViewBuilder private var alertError: some View {
        if viewModel.showErrorAlert {
            CustomErrorAlertView(
                title: "Error",
                message: viewModel.errorMessage ?? "Unknown Error",
                primaryButtonTitle: "Repeat",
                secondaryButtonTitle: "Сlose",
                primaryAction: {
                    viewModel.retryLastAction()
                    viewModel.showErrorAlert = false
                },
                dismissAction: {
                    viewModel.showErrorAlert = false
                }
            )
            .transition(.opacity)
            .zIndex(1)
        }
    }
}

struct ReceiptDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
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
