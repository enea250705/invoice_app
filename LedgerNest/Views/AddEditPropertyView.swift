//
//  AddEditPropertyView.swift
//  LedgerNest
//
//  Form for adding or editing a property
//

import SwiftUI

struct AddEditPropertyView: View {
    @ObservedObject var viewModel: PropertyViewModel
    let property: Property?
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var notes: String = ""
    
    var isEditing: Bool {
        property != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Property Information") {
                    TextField("Property Name *", text: $name)
                    
                    TextField("Address", text: $address)
                        .textInputAutocapitalization(.words)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(isEditing ? "Edit Property" : "Add Property")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Save" : "Add") {
                        saveProperty()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let property = property {
                    name = property.name
                    address = property.address ?? ""
                    notes = property.notes ?? ""
                }
            }
        }
    }
    
    private func saveProperty() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        let trimmedAddress = address.trimmingCharacters(in: .whitespaces)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespaces)
        
        let success: Bool
        if let property = property {
            success = viewModel.updateProperty(
                property,
                name: trimmedName,
                address: trimmedAddress.isEmpty ? nil : trimmedAddress,
                notes: trimmedNotes.isEmpty ? nil : trimmedNotes
            )
        } else {
            success = viewModel.addProperty(
                name: trimmedName,
                address: trimmedAddress.isEmpty ? nil : trimmedAddress,
                notes: trimmedNotes.isEmpty ? nil : trimmedNotes
            )
        }
        
        if success {
            dismiss()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Property.self, Invoice.self, configurations: config)
    let context = container.mainContext
    
    return AddEditPropertyView(
        viewModel: PropertyViewModel(modelContext: context),
        property: nil
    )
    .modelContainer(container)
}

