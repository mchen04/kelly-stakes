//
//  PresetEditView.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import SwiftUI

struct PresetEditView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: PresetViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Input fields section (matches main calculator)
                inputFieldsView
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                Spacer()
                
                // Controls section (matches main calculator)
                controlsView
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .background(Color(.systemBackground))
            .navigationTitle(viewModel.editingPreset == nil ? "New Preset" : "Edit Preset")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewModel.cancelEditing()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.savePreset()
                        dismiss()
                    }
                    .disabled(!viewModel.hasValidEditingInputs || viewModel.isLoading)
                }
            }
        }
        .accessibilityLabel(viewModel.editingPreset == nil ? "Create new preset" : "Edit preset")
    }
    
    // MARK: - Subviews
    
    /// Input fields view - Matches main calculator structure
    private var inputFieldsView: some View {
        VStack(spacing: 16) {
            // Preset name - Unique to preset editing
            InputFieldView.text(
                title: "Preset Name",
                text: $viewModel.editingName,
                errorMessage: viewModel.nameError,
                maxLength: 30
            )
            .accessibilityLabel("Enter preset name")
            
            // Bankroll - Primary input
            InputFieldView.currency(
                title: "Bankroll",
                text: $viewModel.editingBankroll,
                errorMessage: viewModel.bankrollError
            )
            .accessibilityLabel("Enter default bankroll amount")
            
            // Default odds - Side by side like main calculator
            HStack(spacing: 12) {
                InputFieldView.odds(
                    title: "Given Odds",
                    text: $viewModel.editingDefaultGivenOdds,
                    errorMessage: nil,
                    oddsFormat: viewModel.editingOddsFormat
                )
                .accessibilityLabel("Enter default given odds")
                
                InputFieldView.odds(
                    title: "Actual Odds",
                    text: $viewModel.editingDefaultActualOdds,
                    errorMessage: nil,
                    oddsFormat: viewModel.editingOddsFormat
                )
                .accessibilityLabel("Enter default actual odds")
            }
            
            // Kelly multiplier and odds format - Single row like main calculator
            HStack(spacing: 12) {
                InputFieldView.percentage(
                    title: "Kelly Multiplier",
                    text: $viewModel.editingKellyMultiplier,
                    errorMessage: viewModel.kellyMultiplierError
                )
                .accessibilityLabel("Enter Kelly multiplier")
                
                // Compact odds format toggle (matches main calculator)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Format")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Picker("Odds Format", selection: $viewModel.editingOddsFormat) {
                        ForEach(AppConstants.OddsFormat.allCases, id: \.self) { format in
                            Text(format.shortName).tag(format)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .accessibilityLabel("Select preferred odds format")
                }
            }
        }
    }
    
    /// Controls view - Matches main calculator style
    private var controlsView: some View {
        HStack(spacing: 16) {
            // Cancel button - Matches main calculator clear button style
            Button(action: {
                viewModel.cancelEditing()
                dismiss()
            }) {
                HStack {
                    Image(systemName: "xmark")
                        .font(.title3)
                    
                    Text("Cancel")
                        .font(.headline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
            }
            .accessibilityLabel("Cancel editing")
            
            // Save button - Matches main calculator style
            Button(action: {
                viewModel.savePreset()
                dismiss()
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "checkmark")
                            .font(.title3)
                    }
                    
                    Text(viewModel.isLoading ? "Saving..." : "Save")
                        .font(.headline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(viewModel.hasValidEditingInputs ? Color.blue : Color.gray)
                .cornerRadius(12)
            }
            .disabled(!viewModel.hasValidEditingInputs || viewModel.isLoading)
            .accessibilityLabel("Save preset")
        }
    }
}

// MARK: - Preview
#Preview {
    PresetEditView(viewModel: PresetViewModel.preview)
}