//
//  PresetViewModel.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import Foundation
import SwiftUI
import CoreData
import Combine

@MainActor
class PresetViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var presets: [BettingPreset] = []
    @Published var selectedPreset: BettingPreset?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var nextPresetPrice: String = "$1.99"
    @Published var canPurchaseMorePresets = true
    @Published var shouldShowPurchaseView = false
    
    // Editing state
    @Published var isEditing = false
    @Published var editingPreset: BettingPreset?
    @Published var editingName = ""
    @Published var editingBankroll = ""
    @Published var editingKellyMultiplier = ""
    @Published var editingOddsFormat: AppConstants.OddsFormat = .american
    @Published var editingDefaultGivenOdds = ""
    @Published var editingDefaultActualOdds = ""
    
    // Validation
    @Published var nameError: String?
    @Published var bankrollError: String?
    @Published var kellyMultiplierError: String?
    
    // MARK: - Private Properties
    private let persistenceController: PersistenceController
    private let storeKitManager: StoreKitManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var canCreateFreeTierPreset: Bool {
        return persistenceController.canCreateFreeTierPreset()
    }
    
    var canCreateAnotherPreset: Bool {
        return storeKitManager.canCreateAnotherPreset(currentPresetCount: presets.count)
    }
    
    var hasUnusedPurchasedSlots: Bool {
        // With consumables, check if total slots > current preset count
        let totalSlots = storeKitManager.getTotalPresetSlots()
        return presets.count < totalSlots && !canCreateFreeTierPreset
    }
    
    var freeTierPresets: [BettingPreset] {
        return presets.filter { $0.isFreeTier }
    }
    
    var purchasedPresets: [BettingPreset] {
        return presets.filter { !$0.isFreeTier }
    }
    
    var hasValidEditingInputs: Bool {
        return nameError == nil &&
               bankrollError == nil &&
               kellyMultiplierError == nil &&
               !editingName.isEmpty &&
               !editingBankroll.isEmpty &&
               !editingKellyMultiplier.isEmpty
    }
    
    // MARK: - Initialization
    init(
        persistenceController: PersistenceController = .shared,
        storeKitManager: StoreKitManager? = nil
    ) {
        self.persistenceController = persistenceController
        self.storeKitManager = storeKitManager ?? StoreKitManager()
        
        setupValidation()
        loadPresets()
        loadDefaultPreset()
        
        // Update async properties
        Task {
            await updateNextPresetPrice()
            await updatePurchaseAvailability()
        }
    }
    
    // MARK: - Public Methods
    
    /// Load all presets
    func loadPresets() {
        isLoading = true
        errorMessage = nil
        
        presets = persistenceController.getAllPresets()
        
        isLoading = false
    }
    
    /// Load default preset
    func loadDefaultPreset() {
        selectedPreset = persistenceController.getDefaultPreset()
    }
    
    /// Select preset
    /// - Parameter preset: Preset to select
    func selectPreset(_ preset: BettingPreset) {
        selectedPreset = preset
        persistenceController.setDefaultPreset(preset)
    }
    
    /// Start editing preset
    /// - Parameter preset: Preset to edit
    func startEditing(_ preset: BettingPreset) {
        editingPreset = preset
        editingName = preset.safeName
        editingBankroll = preset.safeBankroll.formatted(decimalPlaces: 2)
        editingKellyMultiplier = preset.safeKellyMultiplier.formatted(decimalPlaces: 2)
        editingOddsFormat = preset.oddsFormatEnum
        editingDefaultGivenOdds = preset.defaultGivenOdds ?? ""
        editingDefaultActualOdds = preset.defaultActualOdds ?? ""
        isEditing = true
        
        clearValidationErrors()
    }
    
    /// Start creating new preset
    /// - Parameter isFreeTier: Whether creating a free tier preset
    func startCreating(isFreeTier: Bool = false) {
        // If trying to create free tier but none available, check for purchased slots
        if isFreeTier && !canCreateFreeTierPreset {
            if !canCreateAnotherPreset {
                errorMessage = "No preset slots available. Please purchase a preset first."
                return
            }
            // Continue with paid preset creation
        } else if !isFreeTier && !canCreateAnotherPreset {
            errorMessage = "No purchased preset slots available. Please purchase a preset first."
            return
        }
        
        editingPreset = nil
        editingName = ""
        editingBankroll = "1000"
        editingKellyMultiplier = String(AppConstants.DEFAULT_KELLY_MULTIPLIER)
        editingOddsFormat = .american
        editingDefaultGivenOdds = ""
        editingDefaultActualOdds = ""
        isEditing = true
        
        clearValidationErrors()
    }
    
    /// Save preset
    func savePreset() {
        guard hasValidEditingInputs else { return }
        
        guard let bankrollValue = editingBankroll.currencyDecimalValue,
              let kellyMultiplierValue = Double(editingKellyMultiplier.trimmed) else {
            errorMessage = "Invalid input values"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        if let existingPreset = editingPreset {
            // Update existing preset
            persistenceController.updatePreset(
                existingPreset,
                name: editingName.trimmed,
                bankroll: bankrollValue,
                kellyMultiplier: String(kellyMultiplierValue),
                oddsFormat: editingOddsFormat,
                defaultGivenOdds: editingDefaultGivenOdds,
                defaultActualOdds: editingDefaultActualOdds
            )
        } else {
            // Create new preset
            let isFreeTier = canCreateFreeTierPreset
            var purchaseProductID: String? = nil
            
            if !isFreeTier {
                // This is a purchased preset, determine which product ID to use
                purchaseProductID = getNextPurchasedProductID()
                guard purchaseProductID != nil else {
                    errorMessage = "No purchased preset slots available"
                    isLoading = false
                    return
                }
            }
            
            let newPreset = persistenceController.createPreset(
                name: editingName.trimmed,
                bankroll: bankrollValue,
                kellyMultiplier: String(kellyMultiplierValue),
                oddsFormat: editingOddsFormat,
                defaultGivenOdds: editingDefaultGivenOdds,
                defaultActualOdds: editingDefaultActualOdds,
                isFreeTier: isFreeTier,
                purchaseProductID: purchaseProductID
            )
            
            // If this is the first preset, make it default
            if presets.isEmpty {
                persistenceController.setDefaultPreset(newPreset)
            }
        }
        
        loadPresets()
        cancelEditing()
        
        isLoading = false
    }
    
    /// Cancel editing
    func cancelEditing() {
        isEditing = false
        editingPreset = nil
        editingName = ""
        editingBankroll = ""
        editingKellyMultiplier = ""
        editingOddsFormat = .american
        editingDefaultGivenOdds = ""
        editingDefaultActualOdds = ""
        clearValidationErrors()
    }
    
    /// Delete preset
    /// - Parameter preset: Preset to delete
    func deletePreset(_ preset: BettingPreset) {
        guard preset.canBeDeleted else {
            errorMessage = "Cannot delete default preset"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // If deleting selected preset, select another one
        if selectedPreset?.id == preset.id {
            let remainingPresets = presets.filter { $0.id != preset.id }
            selectedPreset = remainingPresets.first
            if let newDefault = selectedPreset {
                persistenceController.setDefaultPreset(newDefault)
            }
        }
        
        persistenceController.deletePreset(preset)
        loadPresets()
        
        isLoading = false
    }
    
    /// Purchase next preset slot
    func purchaseNextPresetSlot() async -> Bool {
        isLoading = true
        errorMessage = nil
        
        let success = await storeKitManager.purchasePresetSlot()
        
        if success {
            // Create new preset immediately after successful purchase
            let presetNumber = presets.count + 1
            let newPreset = persistenceController.createPreset(
                name: "Preset \(presetNumber)",
                bankroll: 1000,
                kellyMultiplier: "0.25",
                oddsFormat: .american,
                isFreeTier: false,
                purchaseProductID: AppConstants.PRESET_UNLOCK_PRODUCT_ID
            )
            
            // Reload presets to get the updated list
            loadPresets()
            selectedPreset = newPreset
            persistenceController.setDefaultPreset(newPreset)
            
            // Check if user can purchase more
            canPurchaseMorePresets = storeKitManager.canCreateAnotherPreset(currentPresetCount: presets.count)
        } else if let error = storeKitManager.errorMessage {
            errorMessage = error
        }
        
        isLoading = false
        return success
    }
    
    /// Show purchase view for buying additional presets
    func showPurchaseView() {
        shouldShowPurchaseView = true
    }
    
    /// Get next purchased product ID that can be used for preset creation
    private func getNextPurchasedProductID() -> String? {
        // With consumables, we don't track individual product IDs
        // Return the unlock product ID if user has slots available
        if storeKitManager.canCreateAnotherPreset(currentPresetCount: presets.count) {
            return AppConstants.PRESET_UNLOCK_PRODUCT_ID
        }
        return nil
    }
    
    /// Restore purchases
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        
        await storeKitManager.restorePurchases()
        
        if let error = storeKitManager.errorMessage {
            errorMessage = error
        }
        
        isLoading = false
    }
    
    /// Export preset data
    /// - Parameter preset: Preset to export
    /// - Returns: Export data dictionary
    func exportPreset(_ preset: BettingPreset) -> [String: Any] {
        return preset.exportData
    }
    
    /// Get next preset price
    /// - Returns: Formatted price string
    func getNextPresetPrice() -> String {
        return storeKitManager.getPresetUnlockPrice()
    }
    
    /// Update next preset price from StoreKit
    func updateNextPresetPrice() async {
        await MainActor.run {
            nextPresetPrice = storeKitManager.getPresetUnlockPrice()
        }
    }
    
    /// Update purchase availability
    func updatePurchaseAvailability() async {
        await MainActor.run {
            // Consumables can always be purchased
            canPurchaseMorePresets = storeKitManager.getPresetUnlockProduct() != nil
        }
    }
    
    
    // MARK: - Private Methods
    
    /// Setup input validation
    private func setupValidation() {
        // Name validation
        $editingName
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .map { name in
                let result = InputValidator.validatePresetName(name)
                return result.isValid ? nil : result.errorMessage
            }
            .assign(to: \.nameError, on: self)
            .store(in: &cancellables)
        
        // Bankroll validation
        $editingBankroll
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .map { bankroll in
                let result = InputValidator.validateBankroll(bankroll)
                return result.isValid ? nil : result.errorMessage
            }
            .assign(to: \.bankrollError, on: self)
            .store(in: &cancellables)
        
        // Kelly multiplier validation
        $editingKellyMultiplier
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .map { multiplier in
                let result = InputValidator.validateKellyMultiplier(multiplier)
                return result.isValid ? nil : result.errorMessage
            }
            .assign(to: \.kellyMultiplierError, on: self)
            .store(in: &cancellables)
    }
    
    /// Clear validation errors
    private func clearValidationErrors() {
        nameError = nil
        bankrollError = nil
        kellyMultiplierError = nil
    }
}

// MARK: - Preview Support
extension PresetViewModel {
    
    /// Create sample view model for preview
    static var preview: PresetViewModel {
        let viewModel = PresetViewModel(
            persistenceController: .preview,
            storeKitManager: nil
        )
        return viewModel
    }
}