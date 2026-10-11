//
//  ResultsView.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import SwiftUI

struct ResultsView: View {
    
    // MARK: - Properties
    let calculation: KellyCalculation?
    let isCalculating: Bool
    let errorMessage: String?
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 12) {
            // Content - No header to save space
            if isCalculating {
                loadingView
            } else if let errorMessage = errorMessage {
                errorView(errorMessage)
            } else if let calculation = calculation {
                calculationView(calculation)
            } else {
                emptyView
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .animation(.easeInOut(duration: 0.2), value: isCalculating)
        .animation(.easeInOut(duration: 0.2), value: calculation?.id)
    }
    
    // MARK: - Subviews
    
    /// Loading view
    private var loadingView: some View {
        HStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(0.9)
            
            Text("Calculating...")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 12)
    }
    
    /// Error view
    /// - Parameter message: Error message to display
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title)
                .foregroundColor(.red)
            
            Text("Calculation Error")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
    }
    
    /// Empty view - Compact for speed
    private var emptyView: some View {
        HStack {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.title2)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Kelly Recommendation")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Enter all fields for instant calculation")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
    }
    
    /// Calculation view - Optimized for betting speed
    /// - Parameter calculation: Kelly calculation to display
    private func calculationView(_ calculation: KellyCalculation) -> some View {
        VStack(spacing: 12) {
            // Main result - Larger, more prominent
            recommendationCard(calculation)
            
            // Compact details in single row
            compactDetailsRow(calculation)
            
            // Risk indicator - Smaller, less prominent
            riskIndicator(calculation)
        }
    }
    
    /// Recommendation card - Research-optimized typography
    /// - Parameter calculation: Kelly calculation
    private func recommendationCard(_ calculation: KellyCalculation) -> some View {
        VStack(spacing: 6) {
            if calculation.isValidBet {
                HStack {
                    Text("Recommended Bet")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                HStack {
                    Text(calculation.formattedRecommendedBet)
                        .font(.system(size: 32, weight: .bold, design: .default)) // 28-32pt per research
                        .foregroundColor(.green) // Green for confidence
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(calculation.formattedBankrollPercentage)
                            .font(.system(size: 24, weight: .semibold)) // 20-24pt secondary
                            .foregroundColor(.primary)
                        
                        Text("of bankroll")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                HStack {
                    Text("No Bet")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Text("Kelly says pass")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    /// Compact details row - Single line for speed
    /// - Parameter calculation: Kelly calculation
    private func compactDetailsRow(_ calculation: KellyCalculation) -> some View {
        HStack(spacing: 16) {
            // Kelly percentage
            HStack(spacing: 4) {
                Image(systemName: "percent")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text(calculation.formattedKellyPercentage)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            
            Divider()
                .frame(height: 12)
            
            // Multiplier
            HStack(spacing: 4) {
                Image(systemName: "multiply.circle")
                    .font(.caption)
                    .foregroundColor(.purple)
                Text(calculation.formattedKellyMultiplier)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            // Odds format indicator
            Text(calculation.oddsFormat.shortName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray5))
                .cornerRadius(4)
        }
        .padding(.horizontal, 8)
    }
    
    /// Risk indicator - Compact version
    /// - Parameter calculation: Kelly calculation
    private func riskIndicator(_ calculation: KellyCalculation) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "shield.fill")
                .font(.caption)
                .foregroundColor(riskColor(calculation.riskLevel))
            
            Text("Risk: \(calculation.riskLevel.displayName)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(riskColor(calculation.riskLevel))
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(riskColor(calculation.riskLevel).opacity(0.1))
        .cornerRadius(6)
    }
    
    /// Get color for risk level
    /// - Parameter riskLevel: Risk level
    /// - Returns: Color for the risk level
    private func riskColor(_ riskLevel: KellyCalculation.RiskLevel) -> Color {
        switch riskLevel {
        case .low:
            return .green
        case .moderate:
            return .yellow
        case .high:
            return .orange
        case .veryHigh:
            return .red
        }
    }
}

// MARK: - Detail Card
struct DetailCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            HStack {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 24) {
        // With calculation
        ResultsView(
            calculation: KellyCalculation.sample,
            isCalculating: false,
            errorMessage: nil
        )
        
        // Loading
        ResultsView(
            calculation: nil,
            isCalculating: true,
            errorMessage: nil
        )
        
        // Error
        ResultsView(
            calculation: nil,
            isCalculating: false,
            errorMessage: "Invalid odds format"
        )
        
        // Empty
        ResultsView(
            calculation: nil,
            isCalculating: false,
            errorMessage: nil
        )
    }
    .padding()
}