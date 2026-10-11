//
//  StoreKitManager.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import Foundation
import StoreKit
import SwiftUI

class StoreKitManager: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var purchasedPresetSlots: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Track consumable purchases in UserDefaults
    @AppStorage(AppConstants.PURCHASED_PRESET_SLOTS_KEY) private var storedPresetSlots: Int = 0
    
    private let configuredProductIDs = [AppConstants.PRESET_UNLOCK_PRODUCT_ID]
    
    init() {
        // Load purchased slots from UserDefaults
        purchasedPresetSlots = storedPresetSlots
        
        Task {
            await loadProducts()
            await checkForLegacyPurchases()
            await listenForTransactions()
        }
    }
    
    /// Load products from App Store
    func loadProducts() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let loadedProducts = try await Product.products(for: configuredProductIDs)
            await MainActor.run {
                products = loadedProducts
            }
        } catch {
            await MainActor.run {
                errorMessage = "Failed to load products: \(error.localizedDescription)"
            }
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    /// Purchase a product
    /// - Parameter product: Product to purchase
    func purchase(_ product: Product) async -> Bool {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                
                // For consumable purchases, increment the slot count
                if transaction.productID == AppConstants.PRESET_UNLOCK_PRODUCT_ID {
                    await MainActor.run {
                        self.purchasedPresetSlots += 1
                        self.storedPresetSlots = self.purchasedPresetSlots
                    }
                }
                
                await transaction.finish()
                await MainActor.run {
                    isLoading = false
                }
                return true
                
            case .userCancelled:
                await MainActor.run {
                    errorMessage = "Purchase cancelled"
                    isLoading = false
                }
                return false
                
            case .pending:
                await MainActor.run {
                    errorMessage = "Purchase pending"
                    isLoading = false
                }
                return false
                
            default:
                await MainActor.run {
                    errorMessage = "Unknown purchase result"
                    isLoading = false
                }
                return false
            }
        } catch {
            await MainActor.run {
                errorMessage = "Purchase failed: \(error.localizedDescription)"
                isLoading = false
            }
        }
        
        return false
    }
    
    /// Restore purchases
    /// Note: Consumables cannot be restored automatically, but we maintain the count in UserDefaults
    func restorePurchases() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            try await AppStore.sync()
            // For consumables, we rely on UserDefaults storage
            // The count is already loaded from storedPresetSlots
            await MainActor.run {
                errorMessage = "Preset slots restored: \(purchasedPresetSlots) purchased slots"
            }
        } catch {
            await MainActor.run {
                errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
            }
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    /// Get total available preset slots (free + purchased)
    /// - Returns: Total number of preset slots available
    func getTotalPresetSlots() -> Int {
        return AppConstants.FREE_PRESET_LIMIT + purchasedPresetSlots
    }
    
    /// Get the preset unlock product
    /// - Returns: The consumable product for unlocking preset slots
    func getPresetUnlockProduct() -> Product? {
        return products.first { $0.id == AppConstants.PRESET_UNLOCK_PRODUCT_ID }
    }
    
    /// Check for legacy purchases and migrate them
    private func checkForLegacyPurchases() async {
        // Check if user has any legacy non-consumable purchases
        var legacyCount = 0
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                // Count legacy preset purchases
                if transaction.productID.hasPrefix(AppConstants.PRESET_PRODUCT_ID_BASE) &&
                   transaction.productID != AppConstants.PRESET_UNLOCK_PRODUCT_ID {
                    legacyCount += 1
                }
            } catch {
                print("Legacy transaction verification failed: \(error.localizedDescription)")
            }
        }
        
        // Migrate legacy purchases if needed
        let finalLegacyCount = legacyCount
        if finalLegacyCount > 0 && purchasedPresetSlots < finalLegacyCount {
            await MainActor.run { [finalLegacyCount] in
                self.purchasedPresetSlots = max(self.purchasedPresetSlots, finalLegacyCount)
                self.storedPresetSlots = self.purchasedPresetSlots
            }
        }
    }
    
    /// Check if user can create another preset
    /// - Returns: True if user can create more presets
    func canCreateAnotherPreset(currentPresetCount: Int) -> Bool {
        return currentPresetCount < getTotalPresetSlots()
    }
    
    /// Get formatted price for preset unlock
    /// - Returns: Formatted price string
    func getPresetUnlockPrice() -> String {
        guard let product = getPresetUnlockProduct() else {
            return "$\(AppConstants.PRESET_PURCHASE_PRICE)"
        }
        return product.displayPrice
    }
    
    /// Purchase a preset slot
    /// - Returns: Success status
    func purchasePresetSlot() async -> Bool {
        guard let product = getPresetUnlockProduct() else {
            await MainActor.run {
                errorMessage = "Unable to load preset unlock product"
            }
            return false
        }
        
        return await purchase(product)
    }
    
    /// Get number of available slots remaining
    /// - Parameter currentPresetCount: Current number of presets
    /// - Returns: Number of slots available
    func getAvailableSlots(currentPresetCount: Int) -> Int {
        let totalSlots = getTotalPresetSlots()
        return max(0, totalSlots - currentPresetCount)
    }
    
    /// Listen for transactions
    private func listenForTransactions() async {
        for await result in Transaction.updates {
            do {
                let transaction = try checkVerified(result)
                
                // Handle consumable purchase
                if transaction.productID == AppConstants.PRESET_UNLOCK_PRODUCT_ID {
                    await MainActor.run {
                        self.purchasedPresetSlots += 1
                        self.storedPresetSlots = self.purchasedPresetSlots
                    }
                }
                
                await transaction.finish()
            } catch {
                print("Transaction update failed: \(error.localizedDescription)")
            }
        }
    }
    
    /// Check transaction verification
    /// - Parameter result: Verification result
    /// - Returns: Verified transaction
    /// - Throws: Verification error
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreKitError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

// MARK: - StoreKit Errors
enum StoreKitError: Error, LocalizedError {
    case failedVerification
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "Transaction failed verification"
        }
    }
}

// MARK: - Product Extensions
extension Product {
    var formattedPrice: String {
        return displayPrice
    }
    
    var isPresetUnlockProduct: Bool {
        return id == AppConstants.PRESET_UNLOCK_PRODUCT_ID
    }
}