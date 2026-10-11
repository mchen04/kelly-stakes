//
//  AppConstants.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import Foundation

struct AppConstants {
    // Kelly Criterion Constants
    static let MAX_KELLY_MULTIPLIER: Double = 1.0
    static let MIN_KELLY_MULTIPLIER: Double = 0.1
    static let DEFAULT_KELLY_MULTIPLIER: Double = 0.25
    static let MAX_BANKROLL: Decimal = 1000000
    static let MIN_BANKROLL: Decimal = 1
    
    // Preset Constants
    static let FREE_PRESET_LIMIT = 1  // Users get 1 free preset to start
    static let PRESET_PURCHASE_PRICE = 1.99
    
    // StoreKit Product IDs
    static let PRESET_UNLOCK_PRODUCT_ID = "com.kellystakes.preset.unlock"
    
    // UserDefaults Keys for Consumable Tracking
    static let PURCHASED_PRESET_SLOTS_KEY = "kellyStakes.purchasedPresetSlots"
    
    // Legacy product IDs for migration
    static let PRESET_PRODUCT_ID_BASE = "com.kellystakes.preset"
    static let LEGACY_PRESET_PRODUCT_ID = "com.kellystakes.preset"
    
    // UI Constants
    static let ANIMATION_DURATION: Double = 0.3
    static let DEBOUNCE_DELAY: Double = 0.5
    
    // Validation Constants
    static let DECIMAL_PLACES = 2
    static let PERCENTAGE_MULTIPLIER = 100.0
    
    // Odds Format
    enum OddsFormat: String, CaseIterable {
        case american = "American"
        case decimal = "Decimal"
        
        var displayName: String {
            return self.rawValue
        }
        
        var shortName: String {
            switch self {
            case .american:
                return "US"
            case .decimal:
                return "Dec"
            }
        }
    }
}