//
//  ImageStorageService.swift
//  LedgerNest
//
//  Service for managing invoice image storage in documents directory
//

import Foundation
import UIKit

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
    func saveImage(_ image: UIImage) throws -> String {
        let filename = UUID().uuidString + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw ImageStorageError.conversionFailed
        }
        
        try imageData.write(to: fileURL)
        return filename
    }
    
    /// Load image by filename
    func loadImage(filename: String) -> UIImage? {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        guard let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return UIImage(data: imageData)
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

