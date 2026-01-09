//
//  OCRService.swift
//  LedgerNest
//
//  Service for extracting text and data from invoice images using Vision framework
//

import Foundation
#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage
#endif
import Vision
import VisionKit

class OCRService {
    static let shared = OCRService()
    
    private init() {}
    
    /// Extract text from image using Vision framework
    func extractText(from image: PlatformImage, completion: @escaping (String) -> Void) {
        #if canImport(UIKit)
        guard let cgImage = image.cgImage else {
            completion("")
            return
        }
        #elseif canImport(AppKit)
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            completion("")
            return
        }
        #else
        completion("")
        return
        #endif
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion("")
                return
            }
            
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            
            completion(recognizedStrings.joined(separator: " "))
        }
        
        request.recognitionLevel = .accurate
        
        do {
            try requestHandler.perform([request])
        } catch {
            completion("")
        }
    }
    
    /// Extract amount and date from invoice text
    func extractInvoiceData(from text: String) -> (amount: Double?, date: Date?) {
        var amount: Double? = nil
        var date: Date? = nil
        
        // Extract amount - look for currency patterns
        let amountPattern = #"\$?\s*(\d{1,3}(?:,\d{3})*(?:\.\d{2})?)"#
        if let regex = try? NSRegularExpression(pattern: amountPattern, options: []),
           let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
           let range = Range(match.range(at: 1), in: text) {
            let amountString = String(text[range]).replacingOccurrences(of: ",", with: "")
            amount = Double(amountString)
        }
        
        // Extract date - look for common date patterns
        let datePatterns: [(pattern: String, formatters: [String])] = [
            (#"\d{1,2}[/-]\d{1,2}[/-]\d{2,4}"#, ["MM/dd/yyyy", "MM-dd-yyyy", "M/d/yyyy", "M-d-yyyy", "MM/dd/yy", "MM-dd-yy"]),
            (#"\d{4}[/-]\d{1,2}[/-]\d{1,2}"#, ["yyyy-MM-dd", "yyyy/MM/dd", "yyyy-M-d", "yyyy/M/d"]),
            (#"[A-Z][a-z]+\s+\d{1,2},?\s+\d{4}"#, ["MMMM d, yyyy", "MMMM d yyyy", "MMM d, yyyy", "MMM d yyyy"])
        ]
        
        for (pattern, formatterStrings) in datePatterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []),
               let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
               let range = Range(match.range, in: text) {
                let dateString = String(text[range])
                
                // Try each formatter for this pattern
                for formatString in formatterStrings {
                    let formatter = DateFormatter()
                    formatter.dateFormat = formatString
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    if let parsedDate = formatter.date(from: dateString) {
                        date = parsedDate
                        break
                    }
                }
                
                if date != nil {
                    break
                }
            }
        }
        
        return (amount, date)
    }
}

