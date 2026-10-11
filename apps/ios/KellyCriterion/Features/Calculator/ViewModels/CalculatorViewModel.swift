//
//  CalculatorViewModel.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CalculatorViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var bankroll: String = ""
    @Published var givenOdds: String = ""
    @Published var actualOdds: String = ""
    @Published var kellyMultiplier: String = ""
    @Published var oddsFormat: AppConstants.OddsFormat = .american
    
    @Published var calculation: KellyCalculation?
    @Published var isCalculating = false
    @Published var errorMessage: String?
    
    // Validation states
    @Published var bankrollError: String?
    @Published var givenOddsError: String?
    @Published var actualOddsError: String?
    @Published var kellyMultiplierError: String?
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let debounceTime: TimeInterval = 0.5
    
    // MARK: - Computed Properties
    var hasValidInputs: Bool {
        return bankrollError == nil &&
               givenOddsError == nil &&
               actualOddsError == nil &&
               kellyMultiplierError == nil &&
               !bankroll.isEmpty &&
               !givenOdds.isEmpty &&
               !actualOdds.isEmpty &&
               !kellyMultiplier.isEmpty
    }
    
    var canCalculate: Bool {
        return hasValidInputs && !isCalculating
    }
    
    /// Check if we have minimum inputs for partial calculation
    var hasMinimumInputs: Bool {
        // Need at least bankroll and Kelly multiplier for any calculation
        return !bankroll.isEmpty && 
               !kellyMultiplier.isEmpty &&
               bankrollError == nil &&
               kellyMultiplierError == nil
    }
    
    var hasCalculation: Bool {
        return calculation != nil
    }
    
    var isValidBet: Bool {
        return calculation?.isValidBet ?? false
    }
    
    // MARK: - Initialization
    init() {
        setupValidation()
        setupAutoCalculation()
        loadDefaultValues()
    }
    
    // MARK: - Public Methods
    
    /// Load preset values
    /// - Parameter preset: Betting preset to load
    func loadPreset(_ preset: BettingPreset) {
        bankroll = preset.safeBankroll.formatted(decimalPlaces: 2)
        kellyMultiplier = preset.safeKellyMultiplier.formatted(decimalPlaces: 2)
        oddsFormat = preset.oddsFormatEnum
        
        // Load default odds if available, otherwise clear
        givenOdds = preset.defaultGivenOdds ?? ""
        actualOdds = preset.defaultActualOdds ?? ""
        
        // Clear current calculation
        calculation = nil
        errorMessage = nil
    }
    
    /// Calculate Kelly bet (supports partial calculations)
    func calculateBet() {
        guard hasMinimumInputs && !isCalculating else { return }
        
        isCalculating = true
        errorMessage = nil
        
        // Perform calculation on background thread
        Task {
            await performCalculation()
        }
    }
    
    /// Clear all inputs
    func clearAll() {
        bankroll = ""
        givenOdds = ""
        actualOdds = ""
        kellyMultiplier = ""
        calculation = nil
        errorMessage = nil
        clearValidationErrors()
    }
    
    /// Clear calculation result
    func clearCalculation() {
        calculation = nil
        errorMessage = nil
    }
    
    /// Toggle odds format
    func toggleOddsFormat() {
        oddsFormat = oddsFormat == .american ? .decimal : .american
        
        // Convert existing odds if they exist
        convertOddsToNewFormat()
    }
    
    /// Reset to default values
    func resetToDefaults() {
        loadDefaultValues()
        clearCalculation()
        clearValidationErrors()
    }
    
    /// Export calculation data
    func exportCalculation() -> [String: Any]? {
        return calculation?.exportData
    }
    
    // MARK: - Private Methods
    
    /// Setup input validation
    private func setupValidation() {
        // Bankroll validation
        $bankroll
            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
            .map { bankroll in
                let result = InputValidator.validateBankroll(bankroll)
                return result.isValid ? nil : result.errorMessage
            }
            .assign(to: \.bankrollError, on: self)
            .store(in: &cancellables)
        
        // Given odds validation
        Publishers.CombineLatest($givenOdds, $oddsFormat)
            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
            .map { odds, format in
                let result = InputValidator.validateOdds(odds, format: format)
                return result.isValid ? nil : result.errorMessage
            }
            .assign(to: \.givenOddsError, on: self)
            .store(in: &cancellables)
        
        // Actual odds validation
        Publishers.CombineLatest($actualOdds, $oddsFormat)
            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
            .map { odds, format in
                let result = InputValidator.validateOdds(odds, format: format)
                return result.isValid ? nil : result.errorMessage
            }
            .assign(to: \.actualOddsError, on: self)
            .store(in: &cancellables)
        
        // Kelly multiplier validation
        $kellyMultiplier
            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
            .map { multiplier in
                let result = InputValidator.validateKellyMultiplier(multiplier)
                return result.isValid ? nil : result.errorMessage
            }
            .assign(to: \.kellyMultiplierError, on: self)
            .store(in: &cancellables)
    }
    
    /// Setup automatic calculation
    private func setupAutoCalculation() {
        Publishers.CombineLatest4($bankroll, $givenOdds, $actualOdds, $kellyMultiplier)
            .combineLatest($oddsFormat)
            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
            .sink { [weak self] (inputs, format) in
                self?.autoCalculateIfValid()
            }
            .store(in: &cancellables)
    }
    
    /// Auto-calculate if inputs are valid or attempt partial calculation
    private func autoCalculateIfValid() {
        if hasValidInputs {
            calculateBet()
        } else if hasMinimumInputs {
            // Attempt partial calculation for user feedback
            calculateBet()
        }
    }
    
    /// Perform calculation
    private func performCalculation() async {
        guard let bankrollValue = bankroll.currencyDecimalValue,
              let kellyMultiplierValue = Double(kellyMultiplier.trimmed) else {
            await MainActor.run {
                self.errorMessage = "Invalid input values"
                self.isCalculating = false
            }
            return
        }
        
        let result = KellyCalculator.calculateKellyBet(
            bankroll: bankrollValue,
            givenOdds: givenOdds.trimmed,
            actualOdds: actualOdds.trimmed,
            kellyMultiplier: kellyMultiplierValue,
            oddsFormat: oddsFormat
        )
        
        await MainActor.run {
            if let result = result {
                self.calculation = result
                self.errorMessage = nil
            } else {
                self.calculation = nil
                self.errorMessage = "Unable to calculate Kelly bet with current inputs"
            }
            self.isCalculating = false
        }
    }
    
    /// Load default values
    private func loadDefaultValues() {
        bankroll = "1000"
        kellyMultiplier = String(AppConstants.DEFAULT_KELLY_MULTIPLIER)
        oddsFormat = .american
    }
    
    /// Clear validation errors
    private func clearValidationErrors() {
        bankrollError = nil
        givenOddsError = nil
        actualOddsError = nil
        kellyMultiplierError = nil
    }
    
    /// Convert odds to new format
    private func convertOddsToNewFormat() {
        // Convert given odds
        if !givenOdds.isEmpty,
           let convertedGivenOdds = OddsConverter.convertOdds(
               givenOdds,
               from: oddsFormat == .american ? .decimal : .american,
               to: oddsFormat
           ) {
            givenOdds = convertedGivenOdds
        }
        
        // Convert actual odds
        if !actualOdds.isEmpty,
           let convertedActualOdds = OddsConverter.convertOdds(
               actualOdds,
               from: oddsFormat == .american ? .decimal : .american,
               to: oddsFormat
           ) {
            actualOdds = convertedActualOdds
        }
    }
}

// MARK: - Preview Support
extension CalculatorViewModel {
    
    /// Create sample view model for preview
    static var preview: CalculatorViewModel {
        let viewModel = CalculatorViewModel()
        viewModel.bankroll = "5000"
        viewModel.givenOdds = "+150"
        viewModel.actualOdds = "+120"
        viewModel.kellyMultiplier = "0.25"
        viewModel.oddsFormat = .american
        viewModel.calculation = KellyCalculation.sample
        return viewModel
    }
}