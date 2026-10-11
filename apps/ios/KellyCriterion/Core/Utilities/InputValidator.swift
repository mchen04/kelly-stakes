//
//  InputValidator.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import Foundation

struct InputValidator {
    
    /// Validation result with error message
    struct ValidationResult {
        let isValid: Bool
        let errorMessage: String?
        
        static let valid = ValidationResult(isValid: true, errorMessage: nil)
        static func invalid(_ message: String) -> ValidationResult {
            return ValidationResult(isValid: false, errorMessage: message)
        }
    }
    
    /// Validate bankroll input
    /// - Parameter bankroll: Bankroll amount as string
    /// - Returns: ValidationResult
    static func validateBankroll(_ bankroll: String) -> ValidationResult {
        let cleanBankroll = bankroll.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if empty
        if cleanBankroll.isEmpty {
            return .invalid("Bankroll cannot be empty")
        }
        
        // Check if valid decimal (handle currency format with $ prefix)
        guard let bankrollValue = cleanBankroll.currencyDecimalValue else {
            return .invalid("Invalid bankroll format")
        }
        
        // Check minimum value
        if bankrollValue < AppConstants.MIN_BANKROLL {
            return .invalid("Bankroll must be at least $\(AppConstants.MIN_BANKROLL)")
        }
        
        // Check maximum value
        if bankrollValue > AppConstants.MAX_BANKROLL {
            return .invalid("Bankroll cannot exceed $\(AppConstants.MAX_BANKROLL)")
        }
        
        return .valid
    }
    
    /// Validate odds input
    /// - Parameters:
    ///   - odds: Odds string
    ///   - format: Odds format
    /// - Returns: ValidationResult
    static func validateOdds(_ odds: String, format: AppConstants.OddsFormat) -> ValidationResult {
        let cleanOdds = odds.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if empty
        if cleanOdds.isEmpty {
            return .invalid("Odds cannot be empty")
        }
        
        switch format {
        case .american:
            return validateAmericanOdds(cleanOdds)
        case .decimal:
            return validateDecimalOdds(cleanOdds)
        }
    }
    
    /// Validate American odds format
    /// - Parameter odds: American odds string
    /// - Returns: ValidationResult
    private static func validateAmericanOdds(_ odds: String) -> ValidationResult {
        // Check for valid American odds format
        if odds.hasPrefix("+") || odds.hasPrefix("-") {
            let numericString = String(odds.dropFirst())
            guard let oddsValue = Double(numericString), oddsValue > 0 else {
                return .invalid("Invalid American odds format")
            }
            
            // Enforce mathematical constraint: American odds cannot be between -100 and +100
            if oddsValue < 100 {
                if odds.hasPrefix("-") {
                    return .invalid("American odds must be -100 or lower (e.g., -110, -150)")
                } else {
                    return .invalid("American odds must be +100 or higher (e.g., +100, +150)")
                }
            }
            
            // Check maximum reasonable range
            if oddsValue > 10000 {
                return .invalid("American odds cannot exceed ±10000")
            }
            
            return .valid
        } else {
            // Handle positive number without sign (assume positive)
            guard let oddsValue = Double(odds), oddsValue > 0 else {
                return .invalid("Invalid American odds format")
            }
            
            // Enforce minimum +100 constraint for positive odds
            if oddsValue < 100 {
                return .invalid("American odds must be +100 or higher (e.g., +100, +150)")
            }
            
            if oddsValue > 10000 {
                return .invalid("American odds cannot exceed 10000")
            }
            
            return .valid
        }
    }
    
    /// Validate decimal odds format
    /// - Parameter odds: Decimal odds string
    /// - Returns: ValidationResult
    private static func validateDecimalOdds(_ odds: String) -> ValidationResult {
        guard let oddsValue = Double(odds) else {
            return .invalid("Invalid decimal odds format")
        }
        
        // Enforce mathematical constraint: decimal odds must be > 1.0
        if oddsValue <= 1.0 {
            return .invalid("Decimal odds must be greater than 1.0 (represents probability < 100%)")
        }
        
        // Check maximum reasonable value
        if oddsValue > 1000.0 {
            return .invalid("Decimal odds cannot exceed 1000.0")
        }
        
        return .valid
    }
    
    /// Validate Kelly multiplier
    /// - Parameter multiplier: Kelly multiplier as string
    /// - Returns: ValidationResult
    static func validateKellyMultiplier(_ multiplier: String) -> ValidationResult {
        let cleanMultiplier = multiplier.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if empty
        if cleanMultiplier.isEmpty {
            return .invalid("Kelly multiplier cannot be empty")
        }
        
        // Check if valid double
        guard let multiplierValue = Double(cleanMultiplier) else {
            return .invalid("Invalid Kelly multiplier format")
        }
        
        // Check minimum value
        if multiplierValue < AppConstants.MIN_KELLY_MULTIPLIER {
            return .invalid("Kelly multiplier must be at least \(AppConstants.MIN_KELLY_MULTIPLIER)")
        }
        
        // Check maximum value
        if multiplierValue > AppConstants.MAX_KELLY_MULTIPLIER {
            return .invalid("Kelly multiplier cannot exceed \(AppConstants.MAX_KELLY_MULTIPLIER)")
        }
        
        return .valid
    }
    
    /// Validate preset name
    /// - Parameter name: Preset name
    /// - Returns: ValidationResult
    static func validatePresetName(_ name: String) -> ValidationResult {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if empty
        if cleanName.isEmpty {
            return .invalid("Preset name cannot be empty")
        }
        
        // Check length
        if cleanName.count > 30 {
            return .invalid("Preset name cannot exceed 30 characters")
        }
        
        // Check for invalid characters
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet.whitespaces).union(CharacterSet(charactersIn: "-_"))
        if cleanName.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return .invalid("Preset name contains invalid characters")
        }
        
        return .valid
    }
    
    /// Sanitize input string
    /// - Parameter input: Input string
    /// - Returns: Sanitized string
    static func sanitizeInput(_ input: String) -> String {
        return input.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Check if all required fields are filled
    /// - Parameters:
    ///   - bankroll: Bankroll string
    ///   - givenOdds: Given odds string
    ///   - actualOdds: Actual odds string
    ///   - kellyMultiplier: Kelly multiplier string
    /// - Returns: True if all fields are filled
    static func allFieldsFilled(
        bankroll: String,
        givenOdds: String,
        actualOdds: String,
        kellyMultiplier: String
    ) -> Bool {
        return !bankroll.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !givenOdds.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !actualOdds.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !kellyMultiplier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}