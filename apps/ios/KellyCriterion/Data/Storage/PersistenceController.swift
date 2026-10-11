//
//  PersistenceController.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import Foundation

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    
    private let userDefaults = UserDefaults.standard
    private let presetsKey = "BettingPresets"
    
    init() {
        createDefaultPresetIfNeeded()
    }
    
    /// Save presets to UserDefaults
    private func savePresets(_ presets: [BettingPreset]) {
        do {
            let data = try JSONEncoder().encode(presets)
            userDefaults.set(data, forKey: presetsKey)
        } catch {
            print("Failed to save presets: \(error.localizedDescription)")
        }
    }
    
    /// Load presets from UserDefaults
    private func loadPresets() -> [BettingPreset] {
        guard let data = userDefaults.data(forKey: presetsKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([BettingPreset].self, from: data)
        } catch {
            print("Failed to load presets: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Create default preset if none exists
    private func createDefaultPresetIfNeeded() {
        let presets = loadPresets()
        
        if presets.isEmpty {
            let defaultPreset = BettingPreset.createDefault()
            savePresets([defaultPreset])
        }
    }
    
    /// Create a new preset
    /// - Parameters:
    ///   - name: Preset name
    ///   - bankroll: Bankroll amount
    ///   - kellyMultiplier: Kelly multiplier
    ///   - oddsFormat: Odds format
    ///   - isFreeTier: Whether this is a free tier preset
    ///   - purchaseProductID: Product ID used to purchase this preset
    /// - Returns: New BettingPreset
    func createPreset(
        name: String,
        bankroll: Decimal,
        kellyMultiplier: String,
        oddsFormat: AppConstants.OddsFormat,
        defaultGivenOdds: String? = nil,
        defaultActualOdds: String? = nil,
        isFreeTier: Bool = false,
        purchaseProductID: String? = nil
    ) -> BettingPreset {
        var presets = loadPresets()
        
        let newPreset = BettingPreset(
            name: name,
            bankroll: bankroll,
            kellyMultiplier: kellyMultiplier,
            oddsFormat: oddsFormat,
            defaultGivenOdds: defaultGivenOdds?.isEmpty == true ? nil : defaultGivenOdds,
            defaultActualOdds: defaultActualOdds?.isEmpty == true ? nil : defaultActualOdds,
            isDefault: false,
            isFreeTier: isFreeTier,
            purchaseDate: isFreeTier ? nil : Date(),
            purchaseProductID: purchaseProductID
        )
        
        presets.append(newPreset)
        savePresets(presets)
        
        return newPreset
    }
    
    /// Update existing preset
    /// - Parameters:
    ///   - preset: Preset to update
    ///   - name: New name
    ///   - bankroll: New bankroll
    ///   - kellyMultiplier: New Kelly multiplier
    ///   - oddsFormat: New odds format
    func updatePreset(
        _ preset: BettingPreset,
        name: String? = nil,
        bankroll: Decimal? = nil,
        kellyMultiplier: String? = nil,
        oddsFormat: AppConstants.OddsFormat? = nil,
        defaultGivenOdds: String? = nil,
        defaultActualOdds: String? = nil
    ) {
        var presets = loadPresets()
        
        guard let index = presets.firstIndex(where: { $0.id == preset.id }) else { return }
        
        var updatedPreset = presets[index]
        
        if let name = name {
            updatedPreset.name = name
        }
        
        if let bankroll = bankroll {
            updatedPreset.bankroll = bankroll
        }
        
        if let kellyMultiplier = kellyMultiplier {
            updatedPreset.kellyMultiplier = kellyMultiplier
        }
        
        if let oddsFormat = oddsFormat {
            updatedPreset.oddsFormat = oddsFormat.rawValue
        }
        
        if let defaultGivenOdds = defaultGivenOdds {
            updatedPreset.defaultGivenOdds = defaultGivenOdds.isEmpty ? nil : defaultGivenOdds
        }
        
        if let defaultActualOdds = defaultActualOdds {
            updatedPreset.defaultActualOdds = defaultActualOdds.isEmpty ? nil : defaultActualOdds
        }
        
        updatedPreset.updatedAt = Date()
        presets[index] = updatedPreset
        
        savePresets(presets)
    }
    
    /// Delete preset
    /// - Parameter preset: Preset to delete
    func deletePreset(_ preset: BettingPreset) {
        var presets = loadPresets()
        presets.removeAll { $0.id == preset.id }
        savePresets(presets)
    }
    
    /// Set preset as default
    /// - Parameter preset: Preset to set as default
    func setDefaultPreset(_ preset: BettingPreset) {
        var presets = loadPresets()
        
        // Remove default flag from all presets
        for i in 0..<presets.count {
            presets[i].isDefault = false
        }
        
        // Set new default
        guard let index = presets.firstIndex(where: { $0.id == preset.id }) else { return }
        presets[index].isDefault = true
        presets[index].updatedAt = Date()
        
        savePresets(presets)
    }
    
    /// Get default preset
    /// - Returns: Default preset or nil
    func getDefaultPreset() -> BettingPreset? {
        let presets = loadPresets()
        return presets.first { $0.isDefault }
    }
    
    /// Get all presets
    /// - Returns: Array of all presets
    func getAllPresets() -> [BettingPreset] {
        return loadPresets().sorted { $0.createdAt < $1.createdAt }
    }
    
    /// Get free tier presets
    /// - Returns: Array of free tier presets
    func getFreeTierPresets() -> [BettingPreset] {
        return loadPresets().filter { $0.isFreeTier }.sorted { $0.createdAt < $1.createdAt }
    }
    
    /// Get purchased presets
    /// - Returns: Array of purchased presets
    func getPurchasedPresets() -> [BettingPreset] {
        return loadPresets().filter { !$0.isFreeTier }.sorted { $0.purchaseDate ?? Date() < $1.purchaseDate ?? Date() }
    }
    
    /// Check if user can create more free presets
    /// - Returns: True if user can create more free presets
    func canCreateFreeTierPreset() -> Bool {
        let freeTierPresets = getFreeTierPresets()
        return freeTierPresets.count < AppConstants.FREE_PRESET_LIMIT
    }
    
}

// MARK: - Preview Support
extension PersistenceController {
    static var preview: PersistenceController = {
        let controller = PersistenceController()
        
        // Create sample presets for preview
        let samplePresets = [
            BettingPreset.createSample(
                name: "Default",
                bankroll: 1000.0,
                kellyMultiplier: 0.25,
                oddsFormat: .american,
                isDefault: true,
                isFreeTier: true
            ),
            BettingPreset.createSample(
                name: "Conservative",
                bankroll: 5000.0,
                kellyMultiplier: 0.15,
                oddsFormat: .decimal,
                isFreeTier: false
            ),
            BettingPreset.createSample(
                name: "Aggressive",
                bankroll: 2000.0,
                kellyMultiplier: 0.50,
                oddsFormat: .american,
                isFreeTier: false
            )
        ]
        
        controller.savePresets(samplePresets)
        return controller
    }()
}