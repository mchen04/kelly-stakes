//
//  PresetPurchaseView.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import SwiftUI

struct PresetPurchaseView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: PresetViewModel
    @ObservedObject var storeKitManager: StoreKitManager
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    headerView
                    
                    // Features
                    featuresView
                    
                    // Pricing
                    pricingView
                    
                    // Purchase button
                    purchaseButtonView
                    
                    // Restore button
                    restoreButtonView
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Premium Presets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.shouldShowPurchaseView = false
                        dismiss()
                    }
                }
            }
        }
        .accessibilityLabel("Purchase additional presets")
    }
    
    // MARK: - Subviews
    
    /// Header view
    private var headerView: some View {
        VStack(spacing: 16) {
            // Icon
            Image(systemName: "crown.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            // Title
            Text("Premium Presets")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Subtitle
            Text("Purchase individual custom presets for your betting strategies")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    /// Features view
    private var featuresView: some View {
        VStack(spacing: 20) {
            Text("What You Get")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                FeatureRow(
                    icon: "bookmark.fill",
                    title: "Custom Preset",
                    description: "Create and customize your personal betting strategy"
                )
                
                FeatureRow(
                    icon: "speedometer",
                    title: "Quick Access",
                    description: "Switch between strategies instantly"
                )
                
                FeatureRow(
                    icon: "gear",
                    title: "Custom Settings",
                    description: "Personalize bankroll and Kelly multipliers"
                )
                
                FeatureRow(
                    icon: "bookmark.circle",
                    title: "Permanent Storage",
                    description: "Your preset is saved permanently on your device"
                )
            }
        }
        .padding(.horizontal, 4)
    }
    
    /// Pricing view
    private var pricingView: some View {
        VStack(spacing: 12) {
            Text("One-Time Purchase")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack {
                Text(viewModel.getNextPresetPrice())
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text("one-time")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text("No subscriptions, no recurring fees")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    /// Purchase button view
    private var purchaseButtonView: some View {
        Button(action: {
            Task {
                let success = await viewModel.purchaseNextPresetSlot()
                if success {
                    // Automatically start creating the preset after successful purchase
                    viewModel.startCreating(isFreeTier: false)
                    viewModel.shouldShowPurchaseView = false
                    dismiss()
                }
            }
        }) {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "creditcard")
                        .font(.headline)
                }
                
                Text(viewModel.isLoading ? "Processing..." : "Unlock Preset Slot")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                viewModel.isLoading ? Color.gray : Color.blue
            )
            .cornerRadius(12)
        }
        .disabled(viewModel.isLoading)
        .accessibilityLabel("Purchase premium presets")
    }
    
    /// Restore button view
    private var restoreButtonView: some View {
        VStack(spacing: 8) {
            Button(action: {
                Task {
                    await viewModel.restorePurchases()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .font(.subheadline)
                    
                    Text("Check Preset Count")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
            .disabled(viewModel.isLoading)
            .accessibilityLabel("Check purchased preset count")
            
            Text("Your purchased slots are saved locally")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    PresetPurchaseView(
        viewModel: PresetViewModel.preview,
        storeKitManager: StoreKitManager()
    )
}