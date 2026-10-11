//
//  BettingPreset.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import Foundation

struct BettingPreset: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var bankroll: Decimal
    var kellyMultiplier: String
    var oddsFormat: String
    var defaultGivenOdds: String? // New: Store default given odds
    var defaultActualOdds: String? // New: Store default actual odds
    var isDefault: Bool
    var isFreeTier: Bool
    var createdAt: Date
    var updatedAt: Date
    var purchaseDate: Date?
    var purchaseProductID: String? // Product ID used to purchase this preset
    
    init(
        id: UUID = UUID(),
        name: String,
        bankroll: Decimal,
        kellyMultiplier: String,
        oddsFormat: AppConstants.OddsFormat,
        defaultGivenOdds: String? = nil,
        defaultActualOdds: String? = nil,
        isDefault: Bool = false,
        isFreeTier: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        purchaseDate: Date? = nil,
        purchaseProductID: String? = nil
    ) {
        self.id = id
        self.name = name
        self.bankroll = bankroll
        self.kellyMultiplier = kellyMultiplier
        self.oddsFormat = oddsFormat.rawValue
        self.defaultGivenOdds = defaultGivenOdds
        self.defaultActualOdds = defaultActualOdds
        self.isDefault = isDefault
        self.isFreeTier = isFreeTier
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.purchaseDate = purchaseDate
        self.purchaseProductID = purchaseProductID
    }
    
    /// Formatted bankroll
    var formattedBankroll: String {
        return bankroll.currencyFormatted
    }
    
    /// Formatted Kelly multiplier
    var formattedKellyMultiplier: String {
        guard let multiplier = Double(kellyMultiplier) else {
            return AppConstants.DEFAULT_KELLY_MULTIPLIER.percentageFormatted
        }
        return multiplier.percentageFormatted
    }
    
    /// Odds format enum
    var oddsFormatEnum: AppConstants.OddsFormat {
        return AppConstants.OddsFormat(rawValue: oddsFormat) ?? .american
    }
    
    /// Safe bankroll value
    var safeBankroll: Decimal {
        return bankroll
    }
    
    /// Safe Kelly multiplier value
    var safeKellyMultiplier: Double {
        return Double(kellyMultiplier) ?? AppConstants.DEFAULT_KELLY_MULTIPLIER
    }
    
    /// Safe name value
    var safeName: String {
        return name.isEmpty ? "Unnamed Preset" : name
    }
    
    /// Display name with tier indicator
    var displayName: String {
        let safeName = self.safeName
        return isFreeTier ? safeName : "\(safeName) (Premium)"
    }
    
    /// Short display name for tab bar (research-optimized)
    var shortDisplayName: String {
        let safeName = self.safeName
        if safeName.count <= 8 {
            return safeName
        } else {
            // Truncate to 6 chars + ellipsis for tab bar
            return String(safeName.prefix(6)) + "..."
        }
    }
    
    /// Check if preset is valid
    var isValid: Bool {
        guard !name.isEmpty else { return false }
        guard bankroll > 0 else { return false }
        guard let multiplier = Double(kellyMultiplier), multiplier > 0 else { return false }
        guard AppConstants.OddsFormat(rawValue: oddsFormat) != nil else { return false }
        return true
    }
    
    /// Check if preset can be deleted
    var canBeDeleted: Bool {
        // Default preset cannot be deleted
        return !isDefault
    }
    
    /// Check if preset can be edited
    var canBeEdited: Bool {
        // All presets can be edited
        return true
    }
    
    /// Time since creation
    var timeSinceCreation: String {
        return DateFormatter.relativeFormatter.string(from: createdAt)
    }
    
    /// Time since last update
    var timeSinceUpdate: String {
        return DateFormatter.relativeFormatter.string(from: updatedAt)
    }
    
    /// Purchase status
    var purchaseStatus: String {
        if isFreeTier {
            return "Free"
        } else {
            guard let purchaseDate = purchaseDate else { return "Premium" }
            return "Purchased \(DateFormatter.relativeFormatter.string(from: purchaseDate))"
        }
    }
    
    /// Export data for sharing
    var exportData: [String: Any] {
        return [
            "name": safeName,
            "bankroll": bankroll.doubleValue,
            "kellyMultiplier": safeKellyMultiplier,
            "oddsFormat": oddsFormatEnum.rawValue,
            "isDefault": isDefault,
            "isFreeTier": isFreeTier,
            "createdAt": createdAt.timeIntervalSince1970,
            "updatedAt": updatedAt.timeIntervalSince1970
        ]
    }
}

// MARK: - Factory Methods
extension BettingPreset {
    
    /// Create default preset (free starter preset)
    static func createDefault() -> BettingPreset {
        return BettingPreset(
            name: "Default",
            bankroll: 1000,
            kellyMultiplier: String(AppConstants.DEFAULT_KELLY_MULTIPLIER),
            oddsFormat: .american,
            isDefault: true,
            isFreeTier: true,  // First preset is free
            purchaseProductID: nil  // Free preset doesn't need product ID
        )
    }
    
    /// Create sample preset for preview
    static func createSample(
        name: String,
        bankroll: Double,
        kellyMultiplier: Double,
        oddsFormat: AppConstants.OddsFormat,
        defaultGivenOdds: String? = nil,
        defaultActualOdds: String? = nil,
        isDefault: Bool = false,
        isFreeTier: Bool = false,
        purchaseProductID: String? = nil
    ) -> BettingPreset {
        return BettingPreset(
            name: name,
            bankroll: Decimal(bankroll),
            kellyMultiplier: String(kellyMultiplier),
            oddsFormat: oddsFormat,
            defaultGivenOdds: defaultGivenOdds,
            defaultActualOdds: defaultActualOdds,
            isDefault: isDefault,
            isFreeTier: isFreeTier,
            purchaseDate: isFreeTier ? nil : Date(),
            purchaseProductID: isFreeTier ? nil : purchaseProductID
        )
    }
}

// MARK: - DateFormatter Extensions
extension DateFormatter {
    static let relativeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
}