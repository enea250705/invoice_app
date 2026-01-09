//
//  PropertyListView.swift
//  LedgerNest
//
//  Main dashboard showing all properties
//

import SwiftUI

struct PropertyListView: View {
    @ObservedObject var viewModel: PropertyViewModel
    @State private var selectedProperty: Property?
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.properties.isEmpty {
                    emptyStateView
                } else {
                    propertyList
                }
            }
            .navigationTitle("Your Properties")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showingAddProperty = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddProperty) {
                AddEditPropertyView(viewModel: viewModel, property: nil)
            }
            .sheet(item: $viewModel.editingProperty) { property in
                AddEditPropertyView(viewModel: viewModel, property: property)
            }
            .navigationDestination(item: $selectedProperty) { property in
                PropertyDetailView(property: property)
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
            .overlay {
                if viewModel.isSaving {
                    ModernLoadingView()
                }
            }
        }
    }
    
    private var propertyList: some View {
        List {
            ForEach(viewModel.properties) { property in
                PropertyCardView(property: property)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.cardShadow, radius: 4, x: 0, y: 2)
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedProperty = property
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.deleteProperty(property)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            viewModel.editingProperty = property
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.appPrimary)
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private var emptyStateView: some View {
        ModernEmptyState(
            icon: "building.2",
            title: "No properties yet",
            message: "Add your first property to get started managing invoices",
            actionTitle: "Add Property"
        ) {
            viewModel.showingAddProperty = true
        }
    }
}

struct PropertyCardView: View {
    let property: Property
    
    var body: some View {
        HStack(spacing: 16) {
            IconContainer(iconName: "building.2.fill", size: 60, color: .appPrimary)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(property.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let address = property.address, !address.isEmpty {
                    Text(address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack(spacing: 20) {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.text")
                            .font(.caption2)
                        Text("\(property.invoiceCount)")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.caption2)
                        Text(formatCurrency(property.totalExpenses))
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.appPrimary)
                }
                .padding(.top, 2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Property.self, Invoice.self, configurations: config)
    let context = container.mainContext
    
    let property = Property(name: "Sample Property", address: "123 Main St")
    context.insert(property)
    
    return PropertyListView(viewModel: PropertyViewModel(modelContext: context))
        .modelContainer(container)
}

