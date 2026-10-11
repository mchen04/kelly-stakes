//
//  CalculatorView.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import SwiftUI

struct CalculatorView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: CalculatorViewModel
    @State private var showingOddsFormatPicker = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Input fields section
            inputFieldsView
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            
            Spacer()
            
            // Controls section (Bottom - Easy reach zone)
            controlsView
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .background(Color(.systemBackground))
        .hideKeyboard()
        .accessibilityLabel("Kelly Criterion Calculator")
    }
    
    // MARK: - Subviews
    
    /// Input fields view - Optimized for speed and accuracy
    private var inputFieldsView: some View {
        VStack(spacing: 16) {
            // Bankroll - Primary input, largest touch target
            InputFieldView.currency(
                title: "Bankroll",
                text: $viewModel.bankroll,
                errorMessage: viewModel.bankrollError
            )
            .accessibilityLabel("Enter your bankroll amount")
            
            // Odds inputs - Side by side for comparison
            HStack(spacing: 12) {
                InputFieldView.odds(
                    title: "Given Odds",
                    text: $viewModel.givenOdds,
                    errorMessage: viewModel.givenOddsError,
                    oddsFormat: viewModel.oddsFormat
                )
                .accessibilityLabel("Enter the odds offered by the bookmaker")
                
                InputFieldView.odds(
                    title: "Actual Odds",
                    text: $viewModel.actualOdds,
                    errorMessage: viewModel.actualOddsError,
                    oddsFormat: viewModel.oddsFormat
                )
                .accessibilityLabel("Enter your calculated true odds")
            }
            
            // Kelly multiplier and odds format - Single row
            HStack(spacing: 12) {
                InputFieldView.percentage(
                    title: "Kelly Multiplier",
                    text: $viewModel.kellyMultiplier,
                    errorMessage: viewModel.kellyMultiplierError
                )
                .accessibilityLabel("Enter Kelly fraction multiplier")
                
                // Compact odds format toggle
                VStack(alignment: .leading, spacing: 8) {
                    Text("Format")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Picker("Odds Format", selection: $viewModel.oddsFormat) {
                        ForEach(AppConstants.OddsFormat.allCases, id: \.self) { format in
                            Text(format.shortName).tag(format)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .accessibilityLabel("Select odds format")
                }
            }
        }
    }
    
    
    /// Controls view - Minimal, thumb-optimized
    private var controlsView: some View {
        HStack(spacing: 16) {
            // Clear button - Compact version
            Button(action: {
                viewModel.clearAll()
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.title3)
                    
                    Text("Clear")
                        .font(.headline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 48) // Minimum 44pt touch target
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
            }
            .accessibilityLabel("Clear all inputs")
            .accessibilityHint("Clears all input fields and results")
        }
    }
    
}

// MARK: - Preview
#Preview {
    CalculatorView(viewModel: CalculatorViewModel.preview)
}