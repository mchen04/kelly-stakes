//
//  String+Extensions.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import Foundation

extension String {
    
    /// Remove all whitespace and newlines
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Check if string is empty after trimming
    var isEmptyOrWhitespace: Bool {
        return trimmed.isEmpty
    }
    
    /// Convert to Decimal safely
    var decimalValue: Decimal? {
        return Decimal(string: self.trimmed)
    }
    
    /// Convert currency string to Decimal (removes $ prefix)
    var currencyDecimalValue: Decimal? {
        let cleaned = self.trimmed.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")
        return Decimal(string: cleaned)
    }
    
    /// Convert to Double safely
    var doubleValue: Double? {
        return Double(self.trimmed)
    }
    
    /// Format as currency string
    var currencyFormatted: String {
        guard let decimal = decimalValue else { return self }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: decimal as NSDecimalNumber) ?? self
    }
    
    /// Format as percentage string
    var percentageFormatted: String {
        guard let double = doubleValue else { return self }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        
        return formatter.string(from: NSNumber(value: double)) ?? self
    }
    
    /// Check if string represents a valid decimal number
    var isValidDecimal: Bool {
        return decimalValue != nil
    }
    
    /// Check if string represents a valid double number
    var isValidDouble: Bool {
        return doubleValue != nil
    }
    
    /// Sanitize string for preset names
    var sanitizedForPresetName: String {
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet.whitespaces).union(CharacterSet(charactersIn: "-_"))
        return String(self.unicodeScalars.filter { allowedCharacters.contains($0) })
    }
    
    /// Truncate string to specified length
    /// - Parameter length: Maximum length
    /// - Returns: Truncated string
    func truncated(to length: Int) -> String {
        if count <= length {
            return self
        } else {
            return String(prefix(length))
        }
    }
    
    /// Check if string matches American odds format
    var isAmericanOddsFormat: Bool {
        let trimmed = self.trimmed
        
        // Check for +/- prefix
        if trimmed.hasPrefix("+") || trimmed.hasPrefix("-") {
            let numericPart = String(trimmed.dropFirst())
            return numericPart.isValidDouble && Double(numericPart) != nil && Double(numericPart)! > 0
        }
        
        // Check for positive number without prefix
        return trimmed.isValidDouble && Double(trimmed) != nil && Double(trimmed)! > 0
    }
    
    /// Check if string matches decimal odds format
    var isDecimalOddsFormat: Bool {
        guard let value = doubleValue else { return false }
        return value >= 1.0
    }
    
    /// Convert string to title case
    var titleCase: String {
        return self.capitalized
    }
}