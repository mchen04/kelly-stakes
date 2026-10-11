//
//  KellyCalculation.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import Foundation

struct KellyCalculation: Identifiable, Equatable {
    let id = UUID()
    let recommendedBet: Decimal
    let kellyPercentage: Double
    let bankroll: Decimal
    let givenOdds: String
    let actualOdds: String
    let kellyMultiplier: Double
    let oddsFormat: AppConstants.OddsFormat
    let timestamp: Date
    
    init(
        recommendedBet: Decimal,
        kellyPercentage: Double,
        bankroll: Decimal,
        givenOdds: String,
        actualOdds: String,
        kellyMultiplier: Double,
        oddsFormat: AppConstants.OddsFormat
    ) {
        self.recommendedBet = recommendedBet
        self.kellyPercentage = kellyPercentage
        self.bankroll = bankroll
        self.givenOdds = givenOdds
        self.actualOdds = actualOdds
        self.kellyMultiplier = kellyMultiplier
        self.oddsFormat = oddsFormat
        self.timestamp = Date()
    }
    
    /// Formatted recommended bet amount
    var formattedRecommendedBet: String {
        return recommendedBet.currencyFormatted
    }
    
    /// Formatted Kelly percentage
    var formattedKellyPercentage: String {
        return kellyPercentage.percentageFormatted
    }
    
    /// Formatted bankroll
    var formattedBankroll: String {
        return bankroll.currencyFormatted
    }
    
    /// Percentage of bankroll
    var bankrollPercentage: Double {
        let bankrollDouble = bankroll.doubleValue
        return bankrollDouble > 0 ? (recommendedBet.doubleValue / bankrollDouble) : 0.0
    }
    
    /// Formatted bankroll percentage
    var formattedBankrollPercentage: String {
        return bankrollPercentage.percentageFormatted
    }
    
    /// Kelly multiplier formatted as percentage
    var formattedKellyMultiplier: String {
        return kellyMultiplier.percentageFormatted
    }
    
    /// Check if this is a valid bet (positive amount)
    var isValidBet: Bool {
        return recommendedBet > 0
    }
    
    /// Check if this is a significant bet (> 1% of bankroll)
    var isSignificantBet: Bool {
        return bankrollPercentage > 0.01
    }
    
    /// Risk level based on Kelly percentage
    var riskLevel: RiskLevel {
        switch kellyPercentage {
        case 0.0..<0.02:
            return .low
        case 0.02..<0.05:
            return .moderate
        case 0.05..<0.10:
            return .high
        default:
            return .veryHigh
        }
    }
    
    /// Risk level enumeration
    enum RiskLevel: CaseIterable {
        case low, moderate, high, veryHigh
        
        var displayName: String {
            switch self {
            case .low:
                return "Low"
            case .moderate:
                return "Moderate"
            case .high:
                return "High"
            case .veryHigh:
                return "Very High"
            }
        }
        
        var color: String {
            switch self {
            case .low:
                return "green"
            case .moderate:
                return "yellow"
            case .high:
                return "orange"
            case .veryHigh:
                return "red"
            }
        }
    }
    
    /// Summary text for the calculation
    var summaryText: String {
        if !isValidBet {
            return "No bet recommended based on current inputs"
        }
        
        return "Bet \(formattedRecommendedBet) (\(formattedBankrollPercentage) of bankroll)"
    }
    
    /// Detailed description
    var detailedDescription: String {
        return """
        Kelly Calculation Results:
        • Recommended Bet: \(formattedRecommendedBet)
        • Kelly Percentage: \(formattedKellyPercentage)
        • Bankroll Percentage: \(formattedBankrollPercentage)
        • Risk Level: \(riskLevel.displayName)
        • Kelly Multiplier: \(formattedKellyMultiplier)
        • Odds Format: \(oddsFormat.displayName)
        • Given Odds: \(givenOdds)
        • Actual Odds: \(actualOdds)
        """
    }
    
    /// Export data for sharing
    var exportData: [String: Any] {
        return [
            "recommendedBet": recommendedBet.doubleValue,
            "kellyPercentage": kellyPercentage,
            "bankroll": bankroll.doubleValue,
            "givenOdds": givenOdds,
            "actualOdds": actualOdds,
            "kellyMultiplier": kellyMultiplier,
            "oddsFormat": oddsFormat.rawValue,
            "timestamp": timestamp.timeIntervalSince1970
        ]
    }
}

// MARK: - Static Factory Methods
extension KellyCalculation {
    
    /// Create empty calculation
    static var empty: KellyCalculation {
        return KellyCalculation(
            recommendedBet: 0,
            kellyPercentage: 0.0,
            bankroll: 0,
            givenOdds: "",
            actualOdds: "",
            kellyMultiplier: AppConstants.DEFAULT_KELLY_MULTIPLIER,
            oddsFormat: .american
        )
    }
    
    /// Create sample calculation for preview
    static var sample: KellyCalculation {
        return KellyCalculation(
            recommendedBet: 125.50,
            kellyPercentage: 0.0251,
            bankroll: 5000,
            givenOdds: "+150",
            actualOdds: "+120",
            kellyMultiplier: 0.25,
            oddsFormat: .american
        )
    }
}