//
//  InvoiceDetailView.swift
//  LedgerNest
//
//  Detail view for a single invoice
//

import SwiftUI

struct InvoiceDetailView: View {
    let invoice: Invoice
    let invoiceViewModel: InvoiceViewModel?
    
    init(invoice: Invoice, invoiceViewModel: InvoiceViewModel? = nil) {
        self.invoice = invoice
        self.invoiceViewModel = invoiceViewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let image = ImageStorageService.shared.loadImage(filename: invoice.imageFileName) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    InvoiceDetailRow(label: "Amount", value: formatCurrency(invoice.amount))
                    
                    InvoiceDetailRow(label: "Date", value: formatDate(invoice.date))
                    
                    if let vendor = invoice.vendor, !vendor.isEmpty {
                        InvoiceDetailRow(label: "Vendor", value: vendor)
                    }
                    
                    if let property = invoice.property {
                        InvoiceDetailRow(label: "Property", value: property.name)
                    }
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Invoice Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if invoiceViewModel != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        invoiceViewModel?.startEditingInvoice(invoice)
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { invoiceViewModel?.showingInvoiceForm ?? false },
            set: { invoiceViewModel?.showingInvoiceForm = $0 }
        )) {
            if let viewModel = invoiceViewModel,
               let image = viewModel.capturedImage,
               let property = invoice.property {
                InvoiceFormView(
                    invoiceViewModel: viewModel,
                    property: property,
                    image: image
                )
            }
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

struct InvoiceDetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Property.self, Invoice.self, configurations: config)
    let context = container.mainContext
    
    let property = Property(name: "Sample Property")
    let invoice = Invoice(
        imageFileName: "test.jpg",
        amount: 150.00,
        date: Date(),
        vendor: "Test Vendor",
        property: property
    )
    
    return NavigationStack {
        InvoiceDetailView(invoice: invoice)
    }
    .modelContainer(container)
}

