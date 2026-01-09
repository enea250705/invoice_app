//
//  InvoiceViewModel.swift
//  LedgerNest
//
//  ViewModel for managing invoices
//

import Foundation
import SwiftData
#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage
#endif

@MainActor
class InvoiceViewModel: ObservableObject {
    @Published var invoices: [Invoice] = []
    @Published var showingScanner = false
    @Published var capturedImage: PlatformImage?
    @Published var showingInvoiceForm = false
    @Published var selectedProperty: Property?
    
    // Error handling
    @Published var errorMessage: String?
    @Published var showingError = false
    
    // Loading states
    @Published var isProcessingOCR = false
    @Published var isSaving = false
    
    // Invoice editing
    @Published var editingInvoice: Invoice?
    @Published var isPlaceholderImage = false
    
    var modelContext: ModelContext
    private var currentProperty: Property?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
    
    func loadInvoices(for property: Property) {
        self.currentProperty = property
        let descriptor = FetchDescriptor<Invoice>(
            predicate: #Predicate<Invoice> { invoice in
                invoice.property?.id == property.id
            },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        invoices = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func processCapturedImage(_ image: PlatformImage) {
        capturedImage = image
        isPlaceholderImage = false
        isProcessingOCR = true
        
        // Perform OCR
        OCRService.shared.extractText(from: image) { [weak self] text in
            guard let self = self else { return }
            let (amount, date) = OCRService.shared.extractInvoiceData(from: text)
            
            // Set default values from OCR
            DispatchQueue.main.async {
                self.isProcessingOCR = false
                self.pendingAmount = amount ?? 0.0
                self.pendingDate = date ?? Date()
                self.showingInvoiceForm = true
            }
        }
    }
    
    // Pending invoice data
    @Published var pendingAmount: Double = 0.0
    @Published var pendingDate: Date = Date()
    @Published var pendingVendor: String = ""
    
    func validateInvoice() -> String? {
        if pendingAmount <= 0 {
            return "Invoice amount must be greater than zero"
        }
        if pendingDate > Date() {
            return "Invoice date cannot be in the future"
        }
        return nil
    }
    
    func saveInvoice(property: Property) -> Bool {
        // Validate input
        if let validationError = validateInvoice() {
            showError(validationError)
            return false
        }
        
        guard let image = capturedImage else {
            showError("No image available to save")
            return false
        }
        
        isSaving = true
        
        do {
            if let editingInvoice = editingInvoice {
                // Editing existing invoice
                if !isPlaceholderImage {
                    // Only update image if it's not a placeholder
                    // Delete old image and save new one
                    try? ImageStorageService.shared.deleteImage(filename: editingInvoice.imageFileName)
                    let filename = try ImageStorageService.shared.saveImage(image)
                    editingInvoice.imageFileName = filename
                }
                // If it's a placeholder, keep the existing imageFileName
                
                // Update existing invoice
                editingInvoice.amount = pendingAmount
                editingInvoice.date = pendingDate
                editingInvoice.vendor = pendingVendor.isEmpty ? nil : pendingVendor
                editingInvoice.property = property
            } else {
                // Creating new invoice - must have a real image
                if isPlaceholderImage {
                    showError("Please scan or select an invoice image")
                    isSaving = false
                    return false
                }
                let filename = try ImageStorageService.shared.saveImage(image)
                let invoice = Invoice(
                    imageFileName: filename,
                    amount: pendingAmount,
                    date: pendingDate,
                    vendor: pendingVendor.isEmpty ? nil : pendingVendor,
                    property: property
                )
                modelContext.insert(invoice)
            }
            
            try modelContext.save()
            
            // Reset form
            capturedImage = nil
            isPlaceholderImage = false
            pendingAmount = 0.0
            pendingDate = Date()
            pendingVendor = ""
            editingInvoice = nil
            isSaving = false
            
            // Reload invoices
            if let currentProperty = currentProperty {
                loadInvoices(for: currentProperty)
            }
            
            return true
        } catch {
            isSaving = false
            showError("Failed to save invoice: \(error.localizedDescription)")
            return false
        }
    }
    
    func startEditingInvoice(_ invoice: Invoice) {
        editingInvoice = invoice
        pendingAmount = invoice.amount
        pendingDate = invoice.date
        pendingVendor = invoice.vendor ?? ""
        
        // Load the image
        if let image = ImageStorageService.shared.loadImage(filename: invoice.imageFileName) {
            capturedImage = image
            isPlaceholderImage = false
        } else {
            // If image fails to load, show error but still allow editing
            showError("Warning: Invoice image could not be loaded. You can still edit other details, but the image will need to be re-scanned.")
            // Create a placeholder image so the form can still be shown
            capturedImage = UIImage(systemName: "doc.text.fill") ?? UIImage()
            isPlaceholderImage = true
        }
        
        showingInvoiceForm = true
    }
    
    func cancelEditing() {
        editingInvoice = nil
        capturedImage = nil
        isPlaceholderImage = false
        pendingAmount = 0.0
        pendingDate = Date()
        pendingVendor = ""
        showingInvoiceForm = false
    }
    
    func deleteInvoice(_ invoice: Invoice) {
        do {
            // Delete associated image
            try? ImageStorageService.shared.deleteImage(filename: invoice.imageFileName)
            
            modelContext.delete(invoice)
            try modelContext.save()
            
            if let currentProperty = currentProperty {
                loadInvoices(for: currentProperty)
            }
        } catch {
            showError("Failed to delete invoice: \(error.localizedDescription)")
        }
    }
    
    func getInvoicesForMonth(_ month: Int, year: Int) -> [Invoice] {
        return invoices.filter { invoice in
            let components = Calendar.current.dateComponents([.month, .year], from: invoice.date)
            return components.month == month && components.year == year
        }
    }
    
}

