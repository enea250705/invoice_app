//
//  InvoiceFormView.swift
//  LedgerNest
//
//  Form for entering invoice details after scanning
//

import SwiftUI
import SwiftData

struct InvoiceFormView: View {
    @ObservedObject var invoiceViewModel: InvoiceViewModel
    let property: Property
    let image: UIImage
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var allProperties: [Property] = []
    
    var isEditing: Bool {
        invoiceViewModel.editingInvoice != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Invoice Image") {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                        .cornerRadius(8)
                }
                
                Section("Invoice Details") {
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("0.00", value: $invoiceViewModel.pendingAmount, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    DatePicker("Date", selection: $invoiceViewModel.pendingDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    
                    TextField("Vendor (optional)", text: $invoiceViewModel.pendingVendor)
                }
                
                Section("Property") {
                    Picker("Property", selection: $invoiceViewModel.selectedProperty) {
                        ForEach(allProperties) { prop in
                            Text(prop.name).tag(prop as Property?)
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Invoice" : "Invoice Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        invoiceViewModel.cancelEditing()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Save" : "Save") {
                        let selectedProperty = invoiceViewModel.selectedProperty ?? property
                        let success = invoiceViewModel.saveInvoice(property: selectedProperty)
                        if success {
                            dismiss()
                        }
                    }
                    .disabled(invoiceViewModel.pendingAmount <= 0 || invoiceViewModel.isSaving)
                }
            }
            .onAppear {
                if invoiceViewModel.selectedProperty == nil {
                    invoiceViewModel.selectedProperty = property
                }
                loadProperties()
            }
            .alert("Error", isPresented: $invoiceViewModel.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(invoiceViewModel.errorMessage ?? "An unknown error occurred")
            }
            .overlay {
                if invoiceViewModel.isSaving {
                    ModernLoadingView()
                }
            }
        }
    }
    
    private func loadProperties() {
        let descriptor = FetchDescriptor<Property>(sortBy: [SortDescriptor(\.name)])
        allProperties = (try? modelContext.fetch(descriptor)) ?? []
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Property.self, Invoice.self, configurations: config)
    let context = container.mainContext
    
    let property = Property(name: "Sample Property")
    context.insert(property)
    
    return InvoiceFormView(
        invoiceViewModel: InvoiceViewModel(modelContext: context),
        property: property,
        image: UIImage(systemName: "doc.text")!
    )
    .modelContainer(container)
}

