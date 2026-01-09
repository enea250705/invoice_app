//
//  Property.swift
//  LedgerNest
//
//  Property model using SwiftData
//

import Foundation
import SwiftData

@Model
final class Property {
    @Attribute(.unique) var id: UUID
    var name: String
    var address: String?
    var notes: String?
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var invoices: [Invoice]?
    
    init(name: String, address: String? = nil, notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.address = address
        self.notes = notes
        self.createdAt = Date()
        self.invoices = []
    }
    
    // Computed property for total expenses
    var totalExpenses: Double {
        invoices?.reduce(0) { $0 + $1.amount } ?? 0
    }
    
    // Computed property for invoice count
    var invoiceCount: Int {
        invoices?.count ?? 0
    }
}

