//
//  Invoice.swift
//  LedgerNest
//
//  Invoice model using SwiftData
//

import Foundation
import SwiftData

@Model
final class Invoice {
    @Attribute(.unique) var id: UUID
    var imageFileName: String // Name of the image file in documents directory
    var amount: Double
    var date: Date
    var vendor: String?
    var createdAt: Date
    var property: Property?
    
    init(imageFileName: String, amount: Double, date: Date, vendor: String? = nil, property: Property? = nil) {
        self.id = UUID()
        self.imageFileName = imageFileName
        self.amount = amount
        self.date = date
        self.vendor = vendor
        self.createdAt = Date()
        self.property = property
    }
}

