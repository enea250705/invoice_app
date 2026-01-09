//
//  ImageStorageService.swift
//  LedgerNest
//
//  Service for managing invoice image storage in documents directory
//

import Foundation
#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage
#endif

class ImageStorageService {
    static let shared = ImageStorageService()
    
    private let documentsDirectory: URL
    
    private init() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        documentsDirectory = paths[0].appendingPathComponent("InvoiceImages", isDirectory: true)
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
    }
    
    /// Save image and return the filename
    func saveImage(_ image: PlatformImage) throws -> String {
        let filename = UUID().uuidString + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        #if canImport(UIKit)
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw ImageStorageError.conversionFailed
        }
        #elseif canImport(AppKit)
        guard let tiffData = image.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData),
              let imageData = bitmapImage.representation(using: .jpeg, properties: [.compressionFactor: 0.8]) else {
            throw ImageStorageError.conversionFailed
        }
        #else
        throw ImageStorageError.conversionFailed
        #endif
        
        try imageData.write(to: fileURL)
        return filename
    }
    
    /// Load image by filename
    func loadImage(filename: String) -> PlatformImage? {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        guard let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        #if canImport(UIKit)
        return UIImage(data: imageData)
        #elseif canImport(AppKit)
        return NSImage(data: imageData)
        #else
        return nil
        #endif
    }
    
    /// Delete image by filename
    func deleteImage(filename: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        try FileManager.default.removeItem(at: fileURL)
    }
}

enum ImageStorageError: Error {
    case conversionFailed
    case saveFailed
    case loadFailed
}

