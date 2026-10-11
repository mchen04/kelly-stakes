//
//  ContentView.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @StateObject private var presetViewModel = PresetViewModel()
    @StateObject private var calculatorViewModel = CalculatorViewModel()
    @StateObject private var storeKitManager = StoreKitManager()
    
    @State private var selectedTab: String = "calculator"
    @State private var showingPresetEdit = false
    @State private var showingPresetPurchase = false
    @State private var showingSettings = false
    @State private var shouldFlashRed = false
    
    // Age gate
    @AppStorage("hasAcceptedAgeGate") private var hasAcceptedAgeGate = false
    
    // MARK: - Body
    var body: some View {
        if !hasAcceptedAgeGate {
            AgeGateView(hasAcceptedAgeGate: $hasAcceptedAgeGate)
        } else {
            mainAppView
        }
    }
    
    // MARK: - Main App View
    private var mainAppView: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                // Calculator tab - shows currently selected preset
                VStack(spacing: 0) {
                    // Preset selector at top
                    presetSelectorHeader
                    
                    // Hero bet result
                    heroResultView
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    
                    // Calculator interface
                    CalculatorView(viewModel: calculatorViewModel)
                }
                .tabItem {
                    Image(systemName: "percent")
                    Text(presetViewModel.selectedPreset?.shortDisplayName ?? "Calculator")
                }
                .tag("calculator")
                
                // Preset management tab
                PresetManagementView(
                    viewModel: presetViewModel,
                    storeKitManager: storeKitManager
                )
                .tabItem {
                    Image(systemName: "folder")
                    Text("Presets")
                }
                .tag("presets")
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
        }
        .sheet(isPresented: $showingPresetEdit) {
            PresetEditView(viewModel: presetViewModel)
        }
        .sheet(isPresented: $showingPresetPurchase) {
            PresetPurchaseView(
                viewModel: presetViewModel,
                storeKitManager: storeKitManager
            )
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .onReceive(presetViewModel.$isEditing) { isEditing in
            showingPresetEdit = isEditing
        }
        .onReceive(presetViewModel.$selectedPreset) { selectedPreset in
            // Load preset into calculator when selection changes
            if let preset = selectedPreset {
                calculatorViewModel.loadPreset(preset)
            }
        }
        .onReceive(presetViewModel.$shouldShowPurchaseView) { shouldShow in
            showingPresetPurchase = shouldShow
        }
        .onReceive(presetViewModel.$errorMessage) { errorMessage in
            if let error = errorMessage, error.contains("purchase") {
                showingPresetPurchase = true
            }
        }
        .onAppear {
            // Initialize selected preset
            if let defaultPreset = presetViewModel.selectedPreset {
                calculatorViewModel.loadPreset(defaultPreset)
            }
        }
    }
    
    // MARK: - Subviews
    
    /// Preset selector header
    private var presetSelectorHeader: some View {
        HStack {
            if let selectedPreset = presetViewModel.selectedPreset {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Current Preset")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(selectedPreset.safeName)
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        if !selectedPreset.isFreeTier {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                        }
                        
                        if selectedPreset.isDefault {
                            Image(systemName: "checkmark.seal")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    }
                }
                
                Spacer()
                
                Menu {
                    ForEach(presetViewModel.presets, id: \.id) { preset in
                        Button(action: {
                            presetViewModel.selectPreset(preset)
                        }) {
                            HStack {
                                Text(preset.safeName)
                                if preset.id == selectedPreset.id {
                                    Image(systemName: "checkmark")
                                }
                                if !preset.isFreeTier {
                                    Image(systemName: "crown.fill")
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    Button(action: {
                        selectedTab = "presets"
                    }) {
                        Label("Manage Presets", systemImage: "folder")
                    }
                } label: {
                    Image(systemName: "chevron.down.circle")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    Text("No Preset Selected")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Tap Presets tab to get started")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    selectedTab = "presets"
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
    }
    
    /// Hero result view - Research-optimized primary result placement
    private var heroResultView: some View {
        VStack(spacing: 8) {
            // App header with settings
            HStack {
                Text("Kelly Stakes")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Settings button
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gearshape")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .accessibilityLabel("Settings")
                
                // Edit preset menu - Research-optimized gesture access
                Menu {
                    Button(action: {
                        if let selectedPreset = presetViewModel.selectedPreset {
                            presetViewModel.startEditing(selectedPreset)
                        }
                    }) {
                        Label("Edit Preset", systemImage: "pencil")
                    }
                    
                    if let selectedPreset = presetViewModel.selectedPreset, selectedPreset.canBeDeleted {
                        Button(action: {
                            presetViewModel.deletePreset(selectedPreset)
                        }) {
                            Label("Delete Preset", systemImage: "trash")
                        }
                        .foregroundColor(.red)
                    }
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .accessibilityLabel("Preset options")
                .disabled(presetViewModel.selectedPreset == nil)
            }
            
            // Primary bet result (hero display) - Fixed layout, no shifting
            VStack(spacing: 4) {
                HStack {
                    Text("Recommended Bet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if let calculation = calculatorViewModel.calculation, calculation.isValidBet {
                        Text(calculation.formattedBankrollPercentage)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                
                HStack {
                    // Fixed-width container to prevent layout shifts
                    HStack {
                        if let calculation = calculatorViewModel.calculation, calculation.isValidBet {
                            Text(calculation.formattedRecommendedBet)
                                .font(.system(size: 36, weight: .bold, design: .default))
                                .foregroundColor(.green)
                        } else if let calculation = calculatorViewModel.calculation, !calculation.isValidBet && (!calculation.givenOdds.isEmpty && !calculation.actualOdds.isEmpty) {
                            Text("$0.00")
                                .font(.system(size: 36, weight: .bold, design: .default))
                                .foregroundColor(.red)
                        } else {
                            Text("$--")
                                .font(.system(size: 36, weight: .bold, design: .default))
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(minWidth: 160, alignment: .leading) // Fixed minimum width
                    
                    Spacer()
                }
            }
        }
        .padding(16)
        .background(shouldFlashRed ? Color.red.opacity(0.2) : Color(.systemGray6))
        .cornerRadius(12)
        .animation(.easeInOut(duration: 0.2), value: shouldFlashRed)
        .onChange(of: calculatorViewModel.hasMinimumInputs) { _, hasMinimum in
            // Flash red when user has minimum inputs but missing odds
            if hasMinimum && 
               (calculatorViewModel.givenOdds.isEmpty || calculatorViewModel.actualOdds.isEmpty) &&
               calculatorViewModel.calculation?.isValidBet != true {
                triggerRedFlash()
            }
        }
    }
    
    /// Trigger red flash for missing inputs
    private func triggerRedFlash() {
        shouldFlashRed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            shouldFlashRed = false
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}