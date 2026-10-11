//
//  Double+Extensions.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import Foundation

extension Double {
    
    /// Format as currency string
    var currencyFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
    /// Format as percentage string
    var percentageFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: self)) ?? "0.00%"
    }
    
    /// Format as decimal with specified places
    /// - Parameter places: Number of decimal places
    /// - Returns: Formatted string
    func formatted(decimalPlaces places: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = places
        formatter.maximumFractionDigits = places
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
    /// Round to specified decimal places
    /// - Parameter places: Number of decimal places
    /// - Returns: Rounded value
    func rounded(to places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
    
    /// Check if value is within valid Kelly multiplier range
    var isValidKellyMultiplier: Bool {
        return self >= AppConstants.MIN_KELLY_MULTIPLIER && self <= AppConstants.MAX_KELLY_MULTIPLIER
    }
    
    /// Clamp value to valid Kelly multiplier range
    var clampedKellyMultiplier: Double {
        return max(AppConstants.MIN_KELLY_MULTIPLIER, min(AppConstants.MAX_KELLY_MULTIPLIER, self))
    }
    
    /// Convert to Decimal
    var decimal: Decimal {
        return Decimal(self)
    }
    
    /// Check if value is effectively zero (within tolerance)
    var isEffectivelyZero: Bool {
        return abs(self) < 1e-10
    }
    
    /// Convert to percentage (multiply by 100)
    var asPercentage: Double {
        return self * 100.0
    }
    
    /// Convert from percentage (divide by 100)
    var fromPercentage: Double {
        return self / 100.0
    }
    
    /// Safe division that returns nil if dividing by zero
    /// - Parameter divisor: Value to divide by
    /// - Returns: Result of division or nil if divisor is zero
    func safeDivided(by divisor: Double) -> Double? {
        if divisor.isEffectivelyZero {
            return nil
        }
        return self / divisor
    }
    
    /// Get sign of the number
    var sign: String {
        if self > 0 {
            return "+"
        } else if self < 0 {
            return "-"
        } else {
            return ""
        }
    }
    
    /// Get absolute value
    var absoluteValue: Double {
        return abs(self)
    }
}

extension Decimal {
    
    /// Format as currency string
    var currencyFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: self as NSDecimalNumber) ?? "$0.00"
    }
    
    /// Format as decimal with specified places
    /// - Parameter places: Number of decimal places
    /// - Returns: Formatted string
    func formatted(decimalPlaces places: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = places
        formatter.maximumFractionDigits = places
        
        return formatter.string(from: self as NSDecimalNumber) ?? "0"
    }
    
    /// Check if value is within valid bankroll range
    var isValidBankroll: Bool {
        return self >= AppConstants.MIN_BANKROLL && self <= AppConstants.MAX_BANKROLL
    }
    
    /// Clamp value to valid bankroll range
    var clampedBankroll: Decimal {
        return max(AppConstants.MIN_BANKROLL, min(AppConstants.MAX_BANKROLL, self))
    }
    
    /// Convert to Double
    var doubleValue: Double {
        return (self as NSDecimalNumber).doubleValue
    }
    
    /// Check if value is effectively zero
    var isEffectivelyZero: Bool {
        return self == 0
    }
    
    /// Get absolute value
    var absoluteValue: Decimal {
        return abs(self)
    }
}