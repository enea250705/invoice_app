//
//  PropertyDetailView.swift
//  LedgerNest
//
//  Detail view showing all invoices for a property
//

import SwiftUI
import SwiftData

struct PropertyDetailView: View {
    let property: Property
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var invoiceViewModel: InvoiceViewModel
    @State private var showingScanner = false
    @State private var showingInvoiceForm = false
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var showingFilter = false
    @State private var isFiltered = false
    
    init(property: Property) {
        self.property = property
        // Create a temporary in-memory container for initialization
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        if let tempContainer = try? ModelContainer(for: Property.self, Invoice.self, configurations: config) {
            _invoiceViewModel = StateObject(wrappedValue: InvoiceViewModel(modelContext: tempContainer.mainContext))
        } else {
            // Fallback: create a basic container
            let fallbackContainer = try! ModelContainer(for: Property.self, Invoice.self)
            _invoiceViewModel = StateObject(wrappedValue: InvoiceViewModel(modelContext: fallbackContainer.mainContext))
        }
    }
    
    var body: some View {
        Group {
            if invoiceViewModel.invoices.isEmpty {
                emptyStateView
            } else {
                invoiceList
            }
        }
        .navigationTitle(property.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        showingFilter = true
                    }) {
                        Label("Filter by Month", systemImage: "calendar")
                    }
                    
                    Button(action: {
                        showingScanner = true
                    }) {
                        Label("Scan Invoice", systemImage: "camera")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingScanner) {
            InvoiceScannerView(invoiceViewModel: invoiceViewModel, property: property)
        }
        .sheet(isPresented: $showingInvoiceForm) {
            if let image = invoiceViewModel.capturedImage {
                InvoiceFormView(
                    invoiceViewModel: invoiceViewModel,
                    property: property,
                    image: image
                )
            }
        }
        .sheet(isPresented: $showingFilter) {
            FilterView(selectedMonth: $selectedMonth, selectedYear: $selectedYear, isFiltered: $isFiltered)
        }
        .onAppear {
            // Update view model with environment model context
            invoiceViewModel.modelContext = modelContext
            invoiceViewModel.loadInvoices(for: property)
        }
        .onChange(of: invoiceViewModel.showingInvoiceForm) { oldValue, newValue in
            showingInvoiceForm = newValue
        }
        .alert("Error", isPresented: $invoiceViewModel.showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(invoiceViewModel.errorMessage ?? "An unknown error occurred")
        }
        .overlay {
            if invoiceViewModel.isProcessingOCR || invoiceViewModel.isSaving {
                ModernLoadingView()
            }
        }
    }
    
    private var invoiceList: some View {
        List {
            ForEach(filteredInvoices) { invoice in
                NavigationLink(destination: InvoiceDetailView(invoice: invoice, invoiceViewModel: invoiceViewModel)) {
                    InvoiceRowView(invoice: invoice)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.cardShadow.opacity(0.5), radius: 3, x: 0, y: 1)
                )
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        invoiceViewModel.startEditingInvoice(invoice)
                        showingInvoiceForm = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.appPrimary)
                }
            }
            .onDelete { indexSet in
                withAnimation {
                    for index in indexSet {
                        invoiceViewModel.deleteInvoice(filteredInvoices[index])
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private var emptyStateView: some View {
        ModernEmptyState(
            icon: "doc.text",
            title: "No invoices yet",
            message: "Scan your first invoice to start tracking expenses",
            actionTitle: "Scan Invoice"
        ) {
            showingScanner = true
        }
    }
    
    private var filteredInvoices: [Invoice] {
        // Show all invoices if not filtered, otherwise filter by month/year
        if isFiltered {
            return invoiceViewModel.getInvoicesForMonth(selectedMonth, year: selectedYear)
        }
        return invoiceViewModel.invoices
    }
}

struct InvoiceRowView: View {
    let invoice: Invoice
    
    var body: some View {
        HStack(spacing: 14) {
            // Invoice thumbnail
            Group {
                if let image = ImageStorageService.shared.loadImage(filename: invoice.imageFileName) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.secondary.opacity(0.6))
                    }
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cardShadow.opacity(0.3), lineWidth: 0.5)
            )
            .shadow(color: Color.cardShadow.opacity(0.3), radius: 2, x: 0, y: 1)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(formatCurrency(invoice.amount))
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let vendor = invoice.vendor, !vendor.isEmpty {
                    Text(vendor)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(formatDate(invoice.date))
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct FilterView: View {
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Binding var isFiltered: Bool
    @Environment(\.dismiss) private var dismiss
    
    let months = Calendar.current.monthSymbols
    let currentYear = Calendar.current.component(.year, from: Date())
    let years = Array((currentYear - 5)...(currentYear + 1))
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Month", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text(months[month - 1]).tag(month)
                    }
                }
                
                Picker("Year", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
            }
            .navigationTitle("Filter Invoices")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Clear") {
                        isFiltered = false
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        isFiltered = true
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Property.self, Invoice.self, configurations: config)
    let context = container.mainContext
    
    let property = Property(name: "Sample Property", address: "123 Main St")
    context.insert(property)
    
    return NavigationStack {
        PropertyDetailView(property: property)
    }
    .modelContainer(container)
}

