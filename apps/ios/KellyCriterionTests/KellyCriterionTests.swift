//
//  KellyCriterionTests.swift
//  KellyCriterionTests
//
//  Created by Michael Chen on 7/16/25.
//

import Testing
import Foundation
@testable import KellyCriterion

struct KellyCriterionTests {
    
    // MARK: - Kelly Calculator Tests
    
    @Test("Kelly calculation with positive American odds")
    func testKellyCalculationPositiveAmericanOdds() async throws {
        let result = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "+150",
            actualOdds: "+120",
            kellyMultiplier: 1.0,
            oddsFormat: .american
        )
        
        #expect(result != nil)
        #expect(result!.recommendedBet > 0)
        #expect(result!.kellyPercentage > 0)
        #expect(result!.isValidBet == true)
    }
    
    @Test("Kelly calculation with negative American odds")
    func testKellyCalculationNegativeAmericanOdds() async throws {
        let result = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "-110",
            actualOdds: "-105",
            kellyMultiplier: 1.0,
            oddsFormat: .american
        )
        
        #expect(result != nil)
        #expect(result!.recommendedBet >= 0)
        #expect(result!.kellyPercentage >= 0)
    }
    
    @Test("Kelly calculation with decimal odds")
    func testKellyCalculationDecimalOdds() async throws {
        let result = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "2.50",
            actualOdds: "2.20",
            kellyMultiplier: 1.0,
            oddsFormat: .decimal
        )
        
        #expect(result != nil)
        #expect(result!.recommendedBet > 0)
        #expect(result!.kellyPercentage > 0)
        #expect(result!.oddsFormat == .decimal)
    }
    
    @Test("Kelly calculation with Kelly multiplier")
    func testKellyCalculationWithMultiplier() async throws {
        let fullKelly = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "+150",
            actualOdds: "+120",
            kellyMultiplier: 1.0,
            oddsFormat: .american
        )
        
        let halfKelly = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "+150",
            actualOdds: "+120",
            kellyMultiplier: 0.5,
            oddsFormat: .american
        )
        
        #expect(fullKelly != nil)
        #expect(halfKelly != nil)
        #expect(halfKelly!.recommendedBet < fullKelly!.recommendedBet)
        #expect(halfKelly!.kellyPercentage < fullKelly!.kellyPercentage)
    }
    
    @Test("Kelly calculation handles unfavorable odds")
    func testKellyCalculationUnfavorableOdds() async throws {
        let result = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "+120",
            actualOdds: "+150", // Actual odds are worse than given
            kellyMultiplier: 1.0,
            oddsFormat: .american
        )
        
        #expect(result != nil)
        #expect(result!.recommendedBet == 0) // Should recommend no bet
        #expect(result!.kellyPercentage == 0)
    }
    
    @Test("Kelly calculation with zero bankroll")
    func testKellyCalculationZeroBankroll() async throws {
        let result = KellyCalculator.calculateKellyBet(
            bankroll: 0,
            givenOdds: "+150",
            actualOdds: "+120",
            kellyMultiplier: 1.0,
            oddsFormat: .american
        )
        
        #expect(result == nil) // Should return nil for invalid bankroll
    }
    
    @Test("Kelly calculation with empty odds")
    func testKellyCalculationEmptyOdds() async throws {
        let result = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "",
            actualOdds: "+120",
            kellyMultiplier: 1.0,
            oddsFormat: .american
        )
        
        #expect(result != nil)
        #expect(result!.recommendedBet == 0)
        #expect(result!.kellyPercentage == 0)
    }
    
    // MARK: - Odds Validation Tests
    
    @Test("American odds validation - positive")
    func testAmericanOddsValidationPositive() async throws {
        #expect(KellyCalculator.validateOdds("+100", format: .american) == true)
        #expect(KellyCalculator.validateOdds("+150", format: .american) == true)
        #expect(KellyCalculator.validateOdds("100", format: .american) == true) // No sign assumed positive
        #expect(KellyCalculator.validateOdds("+99", format: .american) == false) // Below 100
    }
    
    @Test("American odds validation - negative")
    func testAmericanOddsValidationNegative() async throws {
        #expect(KellyCalculator.validateOdds("-100", format: .american) == true)
        #expect(KellyCalculator.validateOdds("-150", format: .american) == true)
        #expect(KellyCalculator.validateOdds("-99", format: .american) == false) // Above -100
        #expect(KellyCalculator.validateOdds("-50", format: .american) == false)
    }
    
    @Test("Decimal odds validation")
    func testDecimalOddsValidation() async throws {
        #expect(KellyCalculator.validateOdds("1.01", format: .decimal) == true)
        #expect(KellyCalculator.validateOdds("2.50", format: .decimal) == true)
        #expect(KellyCalculator.validateOdds("10.0", format: .decimal) == true)
        #expect(KellyCalculator.validateOdds("1.0", format: .decimal) == false) // Must be > 1.0
        #expect(KellyCalculator.validateOdds("0.5", format: .decimal) == false)
    }
    
    @Test("Invalid odds strings")
    func testInvalidOddsStrings() async throws {
        // Test clearly invalid numeric strings
        #expect(KellyCalculator.validateOdds("++150", format: .american) == false)
        #expect(KellyCalculator.validateOdds("1.a", format: .decimal) == false)
    }
    
    // MARK: - Kelly Multiplier Validation Tests
    
    @Test("Kelly multiplier validation")
    func testKellyMultiplierValidation() async throws {
        #expect(KellyCalculator.validateKellyMultiplier(0.1) == true)
        #expect(KellyCalculator.validateKellyMultiplier(0.25) == true)
        #expect(KellyCalculator.validateKellyMultiplier(1.0) == true)
        #expect(KellyCalculator.validateKellyMultiplier(0.05) == false) // Below minimum
        #expect(KellyCalculator.validateKellyMultiplier(1.5) == false) // Above maximum
        #expect(KellyCalculator.validateKellyMultiplier(0.0) == false)
        #expect(KellyCalculator.validateKellyMultiplier(-0.1) == false)
    }
    
    // MARK: - Bankroll Validation Tests
    
    @Test("Bankroll validation")
    func testBankrollValidation() async throws {
        #expect(KellyCalculator.validateBankroll(Decimal(1)) == true)
        #expect(KellyCalculator.validateBankroll(Decimal(1000)) == true)
        #expect(KellyCalculator.validateBankroll(Decimal(999999)) == true)
        #expect(KellyCalculator.validateBankroll(Decimal(1000000)) == true) // At maximum
        #expect(KellyCalculator.validateBankroll(Decimal(0)) == false)
        #expect(KellyCalculator.validateBankroll(Decimal(-100)) == false)
        #expect(KellyCalculator.validateBankroll(Decimal(1000001)) == false) // Above maximum
    }
    
    // MARK: - Mathematical Accuracy Tests
    
    @Test("Kelly formula mathematical accuracy")
    func testKellyFormulaMathematicalAccuracy() async throws {
        // Test case: +150 given odds, +120 actual odds
        // Given probability: 100/(150+100) = 0.4
        // Actual probability: 100/(120+100) = 0.4545...
        // Kelly = ((1.5 * 0.4545) - 0.5455) / 1.5 = 0.091 (approximately)
        
        let result = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "+150",
            actualOdds: "+120",
            kellyMultiplier: 1.0,
            oddsFormat: .american
        )
        
        #expect(result != nil)
        let expectedKelly = 0.091 // Approximate
        let tolerance = 0.01
        #expect(abs(result!.kellyPercentage - expectedKelly) < tolerance)
    }
    
    @Test("Probability conversion accuracy - American odds")
    func testProbabilityConversionAmericanOdds() async throws {
        // +100 should convert to 0.5 probability
        let result100 = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "+100",
            actualOdds: "+100",
            kellyMultiplier: 1.0,
            oddsFormat: .american
        )
        
        #expect(result100 != nil)
        // When given and actual odds are equal, Kelly should be 0
        let tolerance = 0.001
        #expect(abs(result100!.kellyPercentage - 0.0) < tolerance)
        
        // Test with favorable odds scenario
        let result = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "+200",
            actualOdds: "+150", // Better actual odds (lower positive number means better)
            kellyMultiplier: 1.0,
            oddsFormat: .american
        )
        
        #expect(result != nil)
        #expect(result!.kellyPercentage > 0) // Should be positive Kelly
    }
    
    @Test("Probability conversion accuracy - Decimal odds")
    func testProbabilityConversionDecimalOdds() async throws {
        // 2.0 decimal odds should convert to 0.5 probability
        let result = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "2.0",
            actualOdds: "2.0",
            kellyMultiplier: 1.0,
            oddsFormat: .decimal
        )
        
        #expect(result != nil)
        // When given and actual odds are equal, Kelly should be 0
        #expect(result!.kellyPercentage == 0.0)
    }
    
    // MARK: - Edge Cases
    
    @Test("Very large bankroll")
    func testVeryLargeBankroll() async throws {
        let result = KellyCalculator.calculateKellyBet(
            bankroll: Decimal(500000),
            givenOdds: "+150",
            actualOdds: "+120",
            kellyMultiplier: 0.25,
            oddsFormat: .american
        )
        
        #expect(result != nil)
        #expect(result!.recommendedBet > 0)
        #expect(result!.recommendedBet < result!.bankroll) // Bet should be less than bankroll
    }
    
    @Test("Very small bankroll")
    func testVerySmallBankroll() async throws {
        let result = KellyCalculator.calculateKellyBet(
            bankroll: Decimal(10),
            givenOdds: "+150",
            actualOdds: "+120",
            kellyMultiplier: 1.0,
            oddsFormat: .american
        )
        
        #expect(result != nil)
        #expect(result!.recommendedBet >= 0)
        #expect(result!.recommendedBet <= result!.bankroll)
    }
    
    @Test("Extreme odds values")
    func testExtremeOddsValues() async throws {
        // Very high positive American odds
        let result1 = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "+10000",
            actualOdds: "+5000",
            kellyMultiplier: 1.0,
            oddsFormat: .american
        )
        
        #expect(result1 != nil)
        #expect(result1!.kellyPercentage >= 0)
        
        // Very high negative American odds
        let result2 = KellyCalculator.calculateKellyBet(
            bankroll: 1000,
            givenOdds: "-10000",
            actualOdds: "-5000",
            kellyMultiplier: 1.0,
            oddsFormat: .american
        )
        
        #expect(result2 != nil)
        #expect(result2!.kellyPercentage >= 0)
    }
}
