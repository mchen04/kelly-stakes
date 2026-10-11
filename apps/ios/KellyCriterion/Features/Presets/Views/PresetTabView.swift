//
//  PresetTabView.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import SwiftUI

struct PresetTabView: View {
    
    // MARK: - Properties
    @ObservedObject var presetViewModel: PresetViewModel
    @ObservedObject var calculatorViewModel: CalculatorViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Tab bar
            tabBar
            
            // Selected preset content
            selectedPresetContent
        }
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    // MARK: - Subviews
    
    /// Tab bar
    private var tabBar: some View {
        VStack(spacing: 0) {
            // Existing preset list
            ForEach(presetViewModel.presets, id: \.id) { preset in
                PresetListRow(
                    preset: preset,
                    isSelected: presetViewModel.selectedPreset?.id == preset.id,
                    onTap: {
                        presetViewModel.selectPreset(preset)
                        calculatorViewModel.loadPreset(preset)
                    },
                    onEdit: {
                        presetViewModel.startEditing(preset)
                    },
                    onDelete: {
                        presetViewModel.deletePreset(preset)
                    }
                )
            }
            
            // Add preset button row
            addPresetRow
        }
        .background(Color(.systemBackground))
    }
    
    /// Selected preset content
    private var selectedPresetContent: some View {
        Group {
            if let selectedPreset = presetViewModel.selectedPreset {
                PresetContentView(preset: selectedPreset)
            } else {
                emptyPresetView
            }
        }
        .padding(16)
    }
    
    /// Add preset row
    private var addPresetRow: some View {
        Button(action: {
            if presetViewModel.canCreateFreeTierPreset {
                presetViewModel.startCreating(isFreeTier: true)
            } else if presetViewModel.canCreateAnotherPreset {
                presetViewModel.startCreating(isFreeTier: false)
            } else if presetViewModel.canPurchaseMorePresets {
                // Show purchase view
                presetViewModel.showPurchaseView()
            }
        }) {
            HStack(spacing: 16) {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(buttonColor)
                    .frame(width: 24)
                
                Text(buttonTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
        }
        .disabled(presetViewModel.isLoading || (!presetViewModel.canCreateFreeTierPreset && !presetViewModel.canCreateAnotherPreset && !presetViewModel.canPurchaseMorePresets))
        .accessibilityLabel(accessibilityText)
    }
    
    private var buttonTitle: String {
        if presetViewModel.canCreateFreeTierPreset {
            return "Add"
        } else if presetViewModel.canCreateAnotherPreset {
            return "Add"
        } else if presetViewModel.canPurchaseMorePresets {
            return "Buy \(presetViewModel.getNextPresetPrice())"
        } else {
            return "Full"
        }
    }
    
    private var buttonColor: Color {
        if presetViewModel.canCreateFreeTierPreset {
            return .blue
        } else if presetViewModel.canCreateAnotherPreset {
            return .purple
        } else if presetViewModel.canPurchaseMorePresets {
            return .green
        } else {
            return .gray
        }
    }
    
    private var accessibilityText: String {
        if presetViewModel.canCreateFreeTierPreset {
            return "Add new free preset"
        } else if presetViewModel.canCreateAnotherPreset {
            return "Add new preset using purchased slot"
        } else if presetViewModel.canPurchaseMorePresets {
            return "Purchase additional preset slot"
        } else {
            return "All preset slots used"
        }
    }
    
    /// Empty preset view
    private var emptyPresetView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bookmark")
                .font(.title)
                .foregroundColor(.gray)
            
            Text("No Preset Selected")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Create or select a preset to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
    }
}

// MARK: - Preset List Row
struct PresetListRow: View {
    let preset: BettingPreset
    let isSelected: Bool
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Preset content
                HStack(spacing: 8) {
                    // Default indicator
                    if preset.isDefault {
                        Image(systemName: "checkmark.seal")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    
                    // Preset name
                    Text(preset.safeName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Premium indicator
                    if !preset.isFreeTier {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    
                    // Selection indicator
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        }
        .contextMenu {
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            
            if preset.canBeDeleted {
                Button(action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
                .foregroundColor(.red)
            }
        }
        .accessibilityLabel("Preset: \(preset.safeName)")
        .accessibilityHint(isSelected ? "Selected preset" : "Tap to select preset")
    }
}

// MARK: - Preset Content View
struct PresetContentView: View {
    let preset: BettingPreset
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(preset.safeName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(preset.purchaseStatus)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if preset.isDefault {
                    HStack {
                        Image(systemName: "checkmark.seal")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        
                        Text("Default")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            
            // Details
            VStack(spacing: 12) {
                PresetDetailRow(
                    title: "Bankroll",
                    value: preset.formattedBankroll,
                    icon: "dollarsign.circle"
                )
                
                PresetDetailRow(
                    title: "Kelly Multiplier",
                    value: preset.formattedKellyMultiplier,
                    icon: "multiply.circle"
                )
                
                PresetDetailRow(
                    title: "Odds Format",
                    value: preset.oddsFormatEnum.displayName,
                    icon: "textformat"
                )
            }
            
            // Timestamps
            VStack(alignment: .leading, spacing: 4) {
                Text("Created: \(preset.timeSinceCreation)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Updated: \(preset.timeSinceUpdate)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Preset Detail Row
struct PresetDetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Preview
#Preview {
    PresetTabView(
        presetViewModel: PresetViewModel.preview,
        calculatorViewModel: CalculatorViewModel.preview
    )
    .padding()
}