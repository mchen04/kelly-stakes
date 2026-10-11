//
//  KellyCalculator.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import Foundation

struct KellyCalculator {
    
    /// Calculate Kelly Criterion bet recommendation
    /// - Parameters:
    ///   - bankroll: Current bankroll amount
    ///   - givenOdds: The odds offered by the bookmaker
    ///   - actualOdds: Your calculated true odds
    ///   - kellyMultiplier: Kelly fraction multiplier (0.1 - 1.0)
    ///   - oddsFormat: Whether odds are in American or Decimal format
    /// - Returns: KellyCalculation result with bet amount and percentage
    static func calculateKellyBet(
        bankroll: Decimal,
        givenOdds: String,
        actualOdds: String,
        kellyMultiplier: Double,
        oddsFormat: AppConstants.OddsFormat
    ) -> KellyCalculation? {
        
        // Validate minimum required inputs
        guard bankroll > 0,
              kellyMultiplier > 0 else {
            return nil
        }
        
        // If odds are missing, return a zero calculation for user feedback
        if givenOdds.isEmpty || actualOdds.isEmpty {
            return KellyCalculation(
                recommendedBet: 0,
                kellyPercentage: 0.0,
                bankroll: bankroll,
                givenOdds: givenOdds,
                actualOdds: actualOdds,
                kellyMultiplier: kellyMultiplier,
                oddsFormat: oddsFormat
            )
        }
        
        // Convert odds to decimal probabilities
        guard let givenProbability = convertOddsToProbability(givenOdds, format: oddsFormat),
              let actualProbability = convertOddsToProbability(actualOdds, format: oddsFormat) else {
            return nil
        }
        
        // Calculate Kelly percentage using the Kelly formula
        // Kelly % = (bp - q) / b
        // where b = odds-1 (net odds), p = true probability, q = 1-p
        let givenDecimalOdds = 1.0 / givenProbability
        let b = givenDecimalOdds - 1.0
        let p = actualProbability
        let q = 1.0 - p
        
        let kellyPercentage = (b * p - q) / b
        
        // Apply Kelly multiplier
        let adjustedKellyPercentage = kellyPercentage * kellyMultiplier
        
        // Ensure non-negative percentage
        let finalKellyPercentage = max(0.0, adjustedKellyPercentage)
        
        // Calculate bet amount
        let betAmount = bankroll * Decimal(finalKellyPercentage)
        
        return KellyCalculation(
            recommendedBet: betAmount,
            kellyPercentage: finalKellyPercentage,
            bankroll: bankroll,
            givenOdds: givenOdds,
            actualOdds: actualOdds,
            kellyMultiplier: kellyMultiplier,
            oddsFormat: oddsFormat
        )
    }
    
    /// Convert odds string to probability
    /// - Parameters:
    ///   - odds: Odds string
    ///   - format: Odds format (American or Decimal)
    /// - Returns: Probability as Double (0.0 to 1.0)
    private static func convertOddsToProbability(_ odds: String, format: AppConstants.OddsFormat) -> Double? {
        switch format {
        case .american:
            return convertAmericanOddsToProbability(odds)
        case .decimal:
            return convertDecimalOddsToProbability(odds)
        }
    }
    
    /// Convert American odds to probability
    /// - Parameter odds: American odds string (e.g., "+150", "-200")
    /// - Returns: Probability as Double
    private static func convertAmericanOddsToProbability(_ odds: String) -> Double? {
        let cleanOdds = odds.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Handle positive odds (+150)
        if cleanOdds.hasPrefix("+") {
            let numericString = String(cleanOdds.dropFirst())
            guard let oddsValue = Double(numericString), oddsValue >= 100 else { return nil }
            return 100.0 / (oddsValue + 100.0)
        }
        
        // Handle negative odds (-200)
        if cleanOdds.hasPrefix("-") {
            let numericString = String(cleanOdds.dropFirst())
            guard let oddsValue = Double(numericString), oddsValue >= 100 else { return nil }
            return oddsValue / (oddsValue + 100.0)
        }
        
        // Handle odds without sign (assume positive)
        guard let oddsValue = Double(cleanOdds), oddsValue >= 100 else { return nil }
        return 100.0 / (oddsValue + 100.0)
    }
    
    /// Convert decimal odds to probability
    /// - Parameter odds: Decimal odds string (e.g., "2.50")
    /// - Returns: Probability as Double
    private static func convertDecimalOddsToProbability(_ odds: String) -> Double? {
        let cleanOdds = odds.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oddsValue = Double(cleanOdds), oddsValue > 1.0 else { return nil }
        return 1.0 / oddsValue
    }
}

// MARK: - Validation Extensions
extension KellyCalculator {
    
    /// Validate odds string for given format
    /// - Parameters:
    ///   - odds: Odds string to validate
    ///   - format: Expected odds format
    /// - Returns: True if valid, false otherwise
    static func validateOdds(_ odds: String, format: AppConstants.OddsFormat) -> Bool {
        return convertOddsToProbability(odds, format: format) != nil
    }
    
    /// Validate Kelly multiplier
    /// - Parameter multiplier: Kelly multiplier value
    /// - Returns: True if valid, false otherwise
    static func validateKellyMultiplier(_ multiplier: Double) -> Bool {
        return multiplier >= AppConstants.MIN_KELLY_MULTIPLIER && 
               multiplier <= AppConstants.MAX_KELLY_MULTIPLIER
    }
    
    /// Validate bankroll amount
    /// - Parameter bankroll: Bankroll amount
    /// - Returns: True if valid, false otherwise
    static func validateBankroll(_ bankroll: Decimal) -> Bool {
        return bankroll >= AppConstants.MIN_BANKROLL && 
               bankroll <= AppConstants.MAX_BANKROLL
    }
}