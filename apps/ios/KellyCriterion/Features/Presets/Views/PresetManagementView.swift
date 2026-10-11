//
//  PresetManagementView.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/19/25.
//

import SwiftUI

struct PresetManagementView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: PresetViewModel
    @ObservedObject var storeKitManager: StoreKitManager
    
    @State private var showingPresetEdit = false
    @State private var editingPreset: BettingPreset?
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Main preset list
                List {
                    ForEach(viewModel.presets, id: \.id) { preset in
                        CleanPresetRow(
                            preset: preset,
                            isSelected: preset.id == viewModel.selectedPreset?.id,
                            onSelect: {
                                viewModel.selectPreset(preset)
                            },
                            onEdit: {
                                print("Starting edit for preset: \(preset.safeName)")
                                editingPreset = preset
                                viewModel.startEditing(preset)
                                showingPresetEdit = true
                                print("showingPresetEdit set to: \(showingPresetEdit)")
                            },
                            onDelete: {
                                viewModel.deletePreset(preset)
                            }
                        )
                    }
                    
                    // Add preset row
                    AddPresetRow(
                        canCreateFree: viewModel.canCreateFreeTierPreset,
                        canCreateAnother: viewModel.canCreateAnotherPreset,
                        hasUnusedPurchasedSlots: viewModel.hasUnusedPurchasedSlots,
                        canPurchaseMore: viewModel.canPurchaseMorePresets,
                        price: viewModel.getNextPresetPrice(),
                        isLoading: viewModel.isLoading,
                        onAddFree: {
                            viewModel.startCreating(isFreeTier: true)
                            showingPresetEdit = true
                        },
                        onAddPaid: {
                            viewModel.startCreating(isFreeTier: false)
                            showingPresetEdit = true
                        },
                        onPurchase: {
                            viewModel.showPurchaseView()
                        }
                    )
                }
                .listStyle(PlainListStyle())
            }
            .background(Color(.systemBackground))
            .navigationTitle("Presets")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingPresetEdit) {
            print("Sheet is presenting")
            return PresetEditView(viewModel: viewModel)
                .onDisappear {
                    print("Sheet disappeared")
                    editingPreset = nil
                }
        }
        .onChange(of: showingPresetEdit) { _, isShowing in
            print("showingPresetEdit changed to: \(isShowing)")
        }
    }
    
}

// MARK: - Clean Preset Row Component

struct CleanPresetRow: View {
    let preset: BettingPreset
    let isSelected: Bool
    let onSelect: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    private var hasDefaultOdds: Bool {
        return preset.defaultGivenOdds != nil || preset.defaultActualOdds != nil
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Selection indicator
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
            }
            
            // Preset content
            VStack(alignment: .leading, spacing: 4) {
                // Title row
                HStack {
                    Text(preset.safeName)
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    if !preset.isFreeTier {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                    
                    Spacer()
                }
                
                // Details row
                HStack {
                    Text(preset.formattedBankroll)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Kelly: \(preset.formattedKellyMultiplier)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Odds format badge
                    Text(preset.oddsFormatEnum == .american ? "US" : "DEC")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
                
                // Default odds display (if set)
                if hasDefaultOdds {
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(.green)
                            .font(.caption2)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            if let givenOdds = preset.defaultGivenOdds {
                                Text("Given: \(givenOdds)")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                            }
                            if let actualOdds = preset.defaultActualOdds {
                                Text("Actual: \(actualOdds)")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            
            // Edit button
            Button(action: {
                print("Edit button tapped for preset: \(preset.safeName)")
                onEdit()
            }) {
                Image(systemName: "pencil.circle")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
        .onTapGesture {
            onSelect()
        }
        .accessibilityLabel("\(preset.safeName) preset")
        .accessibilityHint(isSelected ? "Currently selected" : "Tap to select this preset")
    }
}

// MARK: - Add Preset Row Component

struct AddPresetRow: View {
    let canCreateFree: Bool
    let canCreateAnother: Bool
    let hasUnusedPurchasedSlots: Bool
    let canPurchaseMore: Bool
    let price: String
    let isLoading: Bool
    let onAddFree: () -> Void
    let onAddPaid: () -> Void
    let onPurchase: () -> Void
    
    private var buttonAction: () -> Void {
        if canCreateFree {
            return onAddFree
        } else if hasUnusedPurchasedSlots {
            return onAddPaid
        } else {
            return onPurchase
        }
    }
    
    private var buttonTitle: String {
        if canCreateFree {
            return "Add Free Preset"
        } else if hasUnusedPurchasedSlots {
            return "Create New Preset"
        } else {
            return "Buy Extra Preset"
        }
    }
    
    private var buttonSubtitle: String {
        if canCreateFree {
            return "Create your first custom preset"
        } else if hasUnusedPurchasedSlots {
            return "Use your purchased preset slot"
        } else {
            return "Purchase \(price) preset and customize it"
        }
    }
    
    private var buttonIcon: String {
        if canCreateFree {
            return "plus.circle.fill"
        } else if hasUnusedPurchasedSlots {
            return "bookmark.fill"
        } else {
            return "crown.fill"
        }
    }
    
    private var iconColor: Color {
        if canCreateFree {
            return .blue
        } else if hasUnusedPurchasedSlots {
            return .purple
        } else {
            return .green
        }
    }
    
    var body: some View {
        Button(action: buttonAction) {
            HStack(spacing: 12) {
                Image(systemName: buttonIcon)
                    .foregroundColor(iconColor)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(buttonTitle)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(buttonSubtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else if canCreateFree || canCreateAnother {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                } else {
                    // Always show chevron for purchase option
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .padding(.vertical, 12)
        }
        .disabled(isLoading)
    }
}

// MARK: - Clean Preset Card Component

struct CleanPresetCard: View {
    let preset: BettingPreset
    let isSelected: Bool
    let onSelect: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with indicators
            HStack {
                HStack(spacing: 4) {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                    
                    if !preset.isFreeTier {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Menu {
                    Button(action: onEdit) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    if preset.canBeDeleted {
                        Button(action: onDelete) {
                            Label("Delete", systemImage: "trash")
                        }
                        .foregroundColor(.red)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .padding(4)
                }
            }
            
            // Preset info
            VStack(alignment: .leading, spacing: 6) {
                Text(preset.safeName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(preset.formattedBankroll)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                HStack {
                    Text("Kelly \(preset.formattedKellyMultiplier)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(preset.oddsFormatEnum == .american ? "US" : "DEC")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .frame(height: 120)
        .background(isSelected ? Color.blue.opacity(0.05) : Color(.systemGray6))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1.5)
        )
        .cornerRadius(12)
        .onTapGesture {
            onSelect()
        }
        .accessibilityLabel("\(preset.safeName) preset")
        .accessibilityHint(isSelected ? "Currently selected" : "Tap to select this preset")
    }
}

// MARK: - Original Preset Card Component

struct PresetCard: View {
    let preset: BettingPreset
    let isSelected: Bool
    let onSelect: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    private var indicatorBadges: some View {
        HStack(spacing: 4) {
            if !preset.isFreeTier {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                    .font(.caption2)
            }
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.caption2)
            }
        }
    }
    
    private var menuButton: some View {
        Menu {
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            
            if preset.canBeDeleted {
                Button(action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
                .foregroundColor(.red)
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with premium indicator and edit button
            HStack {
                indicatorBadges
                Spacer()
                menuButton
            }
            
            // Preset details
            VStack(alignment: .leading, spacing: 6) {
                Text(preset.safeName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(preset.formattedBankroll)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Kelly: \(preset.formattedKellyMultiplier)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(preset.oddsFormatEnum.shortName)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(4)
            }
            
            Spacer()
        }
        .padding(12)
        .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .cornerRadius(12)
        .onTapGesture {
            onSelect()
        }
        .accessibilityLabel("\(preset.safeName) preset")
        .accessibilityHint(isSelected ? "Currently selected" : "Tap to select this preset")
    }
}


// MARK: - Preview
#Preview {
    PresetManagementView(
        viewModel: PresetViewModel.preview,
        storeKitManager: StoreKitManager()
    )
}