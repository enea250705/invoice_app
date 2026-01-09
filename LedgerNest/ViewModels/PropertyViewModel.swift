//
//  PropertyViewModel.swift
//  LedgerNest
//
//  ViewModel for managing properties
//

import Foundation
import SwiftData

@MainActor
class PropertyViewModel: ObservableObject {
    @Published var properties: [Property] = []
    @Published var showingAddProperty = false
    @Published var editingProperty: Property?
    
    // Error handling
    @Published var errorMessage: String?
    @Published var showingError = false
    
    // Loading state
    @Published var isSaving = false
    
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadProperties()
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
    
    func loadProperties() {
        let descriptor = FetchDescriptor<Property>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        properties = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func addProperty(name: String, address: String?, notes: String?) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else {
            showError("Property name cannot be empty")
            return false
        }
        
        isSaving = true
        do {
            let property = Property(name: trimmedName, address: address, notes: notes)
            modelContext.insert(property)
            try modelContext.save()
            isSaving = false
            loadProperties()
            return true
        } catch {
            isSaving = false
            showError("Failed to save property: \(error.localizedDescription)")
            return false
        }
    }
    
    func updateProperty(_ property: Property, name: String, address: String?, notes: String?) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else {
            showError("Property name cannot be empty")
            return false
        }
        
        isSaving = true
        do {
            property.name = trimmedName
            property.address = address
            property.notes = notes
            try modelContext.save()
            isSaving = false
            loadProperties()
            return true
        } catch {
            isSaving = false
            showError("Failed to update property: \(error.localizedDescription)")
            return false
        }
    }
    
    func deleteProperty(_ property: Property) {
        do {
            // Delete associated invoice images
            if let invoices = property.invoices {
                for invoice in invoices {
                    try? ImageStorageService.shared.deleteImage(filename: invoice.imageFileName)
                }
            }
            
            modelContext.delete(property)
            try modelContext.save()
            loadProperties()
        } catch {
            showError("Failed to delete property: \(error.localizedDescription)")
        }
    }
}

