//
//  OddsConverter.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import Foundation

struct OddsConverter {
    
    /// Convert American odds to Decimal odds
    /// - Parameter americanOdds: American odds string (e.g., "+150", "-200")
    /// - Returns: Decimal odds string
    static func americanToDecimal(_ americanOdds: String) -> String? {
        let cleanOdds = americanOdds.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Handle positive odds (+150)
        if cleanOdds.hasPrefix("+") {
            let numericString = String(cleanOdds.dropFirst())
            guard let oddsValue = Double(numericString), oddsValue > 0 else { return nil }
            let decimalOdds = 1.0 + (oddsValue / 100.0)
            return String(format: "%.2f", decimalOdds)
        }
        
        // Handle negative odds (-200)
        if cleanOdds.hasPrefix("-") {
            let numericString = String(cleanOdds.dropFirst())
            guard let oddsValue = Double(numericString), oddsValue > 0 else { return nil }
            let decimalOdds = 1.0 + (100.0 / oddsValue)
            return String(format: "%.2f", decimalOdds)
        }
        
        // Handle odds without sign (assume positive)
        guard let oddsValue = Double(cleanOdds), oddsValue > 0 else { return nil }
        let decimalOdds = 1.0 + (oddsValue / 100.0)
        return String(format: "%.2f", decimalOdds)
    }
    
    /// Convert Decimal odds to American odds
    /// - Parameter decimalOdds: Decimal odds string (e.g., "2.50")
    /// - Returns: American odds string
    static func decimalToAmerican(_ decimalOdds: String) -> String? {
        let cleanOdds = decimalOdds.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oddsValue = Double(cleanOdds), oddsValue >= 1.0 else { return nil }
        
        if oddsValue >= 2.0 {
            // Positive American odds
            let americanOdds = Int((oddsValue - 1.0) * 100.0)
            return "+\(americanOdds)"
        } else {
            // Negative American odds
            let americanOdds = Int(100.0 / (oddsValue - 1.0))
            return "-\(americanOdds)"
        }
    }
    
    /// Convert odds between formats
    /// - Parameters:
    ///   - odds: Input odds string
    ///   - fromFormat: Source format
    ///   - toFormat: Target format
    /// - Returns: Converted odds string
    static func convertOdds(
        _ odds: String,
        from fromFormat: AppConstants.OddsFormat,
        to toFormat: AppConstants.OddsFormat
    ) -> String? {
        
        guard fromFormat != toFormat else { return odds }
        
        switch (fromFormat, toFormat) {
        case (.american, .decimal):
            return americanToDecimal(odds)
        case (.decimal, .american):
            return decimalToAmerican(odds)
        default:
            return odds
        }
    }
    
    /// Get probability from odds in any format
    /// - Parameters:
    ///   - odds: Odds string
    ///   - format: Odds format
    /// - Returns: Probability as percentage string
    static func oddsToImpliedProbability(_ odds: String, format: AppConstants.OddsFormat) -> String? {
        let probability: Double?
        
        switch format {
        case .american:
            probability = americanOddsToImpliedProbability(odds)
        case .decimal:
            probability = decimalOddsToImpliedProbability(odds)
        }
        
        guard let prob = probability else { return nil }
        return String(format: "%.1f%%", prob * 100.0)
    }
    
    /// Convert American odds to implied probability
    /// - Parameter odds: American odds string
    /// - Returns: Probability as Double (0.0 to 1.0)
    private static func americanOddsToImpliedProbability(_ odds: String) -> Double? {
        let cleanOdds = odds.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Handle positive odds (+150)
        if cleanOdds.hasPrefix("+") {
            let numericString = String(cleanOdds.dropFirst())
            guard let oddsValue = Double(numericString), oddsValue > 0 else { return nil }
            return 100.0 / (oddsValue + 100.0)
        }
        
        // Handle negative odds (-200)
        if cleanOdds.hasPrefix("-") {
            let numericString = String(cleanOdds.dropFirst())
            guard let oddsValue = Double(numericString), oddsValue > 0 else { return nil }
            return oddsValue / (oddsValue + 100.0)
        }
        
        // Handle odds without sign (assume positive)
        guard let oddsValue = Double(cleanOdds), oddsValue > 0 else { return nil }
        return 100.0 / (oddsValue + 100.0)
    }
    
    /// Convert decimal odds to implied probability
    /// - Parameter odds: Decimal odds string
    /// - Returns: Probability as Double (0.0 to 1.0)
    private static func decimalOddsToImpliedProbability(_ odds: String) -> Double? {
        let cleanOdds = odds.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oddsValue = Double(cleanOdds), oddsValue >= 1.0 else { return nil }
        return 1.0 / oddsValue
    }
}