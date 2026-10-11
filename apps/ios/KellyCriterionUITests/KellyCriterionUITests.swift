//
//  KellyCriterionUITests.swift
//  KellyCriterionUITests
//
//  Created by Michael Chen on 7/16/25.
//

import XCTest

final class KellyCriterionUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testCalculatorBasicFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Test basic calculator input flow
        let bankrollField = app.textFields["Bankroll"]
        let givenOddsField = app.textFields["Given Odds"]
        let actualOddsField = app.textFields["Actual Odds"]
        let kellyMultiplierField = app.textFields["Kelly Multiplier"]
        
        // Input valid data
        bankrollField.tap()
        bankrollField.typeText("1000")
        
        givenOddsField.tap()
        givenOddsField.typeText("+150")
        
        actualOddsField.tap()
        actualOddsField.typeText("+120")
        
        kellyMultiplierField.tap()
        kellyMultiplierField.typeText("0.25")
        
        // Verify calculation results appear
        let betAmountText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS '$'")).firstMatch
        XCTAssertTrue(betAmountText.exists, "Bet amount should be displayed")
        XCTAssertTrue(betAmountText.waitForExistence(timeout: 2.0))
    }
    
    @MainActor
    func testOddsFormatToggle() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Find and tap odds format toggle
        let oddsFormatButton = app.buttons["American"]
        XCTAssertTrue(oddsFormatButton.exists, "Odds format button should exist")
        
        oddsFormatButton.tap()
        
        // Verify toggle changes to Decimal
        let decimalButton = app.buttons["Decimal"]
        XCTAssertTrue(decimalButton.waitForExistence(timeout: 2.0), "Should switch to Decimal format")
        
        // Toggle back
        decimalButton.tap()
        XCTAssertTrue(oddsFormatButton.waitForExistence(timeout: 2.0), "Should switch back to American format")
    }
    
    @MainActor
    func testQuickOddsInput() throws {
        let app = XCUIApplication()
        app.launch()
        
        let givenOddsField = app.textFields["Given Odds"]
        givenOddsField.tap()
        
        // Test +/- symbol buttons for American odds
        let plusButton = app.buttons["+"]
        let minusButton = app.buttons["-"]
        
        if plusButton.exists {
            plusButton.tap()
            givenOddsField.typeText("150")
            XCTAssertTrue(givenOddsField.value as? String == "+150" || 
                         (givenOddsField.value as? String)?.contains("150") == true)
        }
        
        // Clear and test minus
        givenOddsField.doubleTap()
        if minusButton.exists {
            minusButton.tap()
            givenOddsField.typeText("110")
            XCTAssertTrue(givenOddsField.value as? String == "-110" || 
                         (givenOddsField.value as? String)?.contains("110") == true)
        }
    }
    
    @MainActor
    func testPresetSwitching() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Check for preset tabs at bottom
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists, "Tab bar should exist")
        
        // Test switching between presets
        let defaultTab = app.buttons["Default"]
        if defaultTab.exists {
            defaultTab.tap()
            
            // Verify preset loads
            let bankrollField = app.textFields["Bankroll"]
            XCTAssertTrue(bankrollField.exists, "Bankroll field should exist in preset")
        }
        
        // Test add preset functionality (should show purchase flow)
        let addPresetTab = app.buttons.matching(NSPredicate(format: "label CONTAINS '+' OR label CONTAINS 'Add' OR label CONTAINS '$1.99'")).firstMatch
        if addPresetTab.exists {
            addPresetTab.tap()
            
            // Should show purchase view or add preset view
            let purchaseView = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Additional Presets' OR label CONTAINS '$1.99'")).firstMatch
            XCTAssertTrue(purchaseView.waitForExistence(timeout: 3.0), "Purchase view should appear")
        }
    }
    
    @MainActor
    func testInputValidation() throws {
        let app = XCUIApplication()
        app.launch()
        
        let bankrollField = app.textFields["Bankroll"]
        let givenOddsField = app.textFields["Given Odds"]
        
        // Test invalid bankroll
        bankrollField.tap()
        bankrollField.typeText("0")
        
        // Tap somewhere else to trigger validation
        givenOddsField.tap()
        
        // Check for visual validation (red border would be visual, not easily testable)
        // But we can verify the calculation doesn't produce invalid results
        let betAmountElements = app.staticTexts.containing(NSPredicate(format: "label CONTAINS '$'"))
        if betAmountElements.count > 0 {
            let betAmount = betAmountElements.firstMatch.label
            XCTAssertTrue(betAmount.contains("$0") || betAmount.contains("$0.00"), "Should show zero bet for invalid bankroll")
        }
        
        // Test invalid American odds
        givenOddsField.doubleTap()
        givenOddsField.typeText("+50") // Below minimum +100
        
        bankrollField.tap()
        bankrollField.typeText("1000")
        
        // Should not produce valid calculation
        // Visual validation would appear as red borders
    }
    
    @MainActor
    func testPurchaseFlowNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to purchase flow
        let addPresetButton = app.buttons.matching(NSPredicate(format: "label CONTAINS '+' OR label CONTAINS 'Add' OR label CONTAINS '$1.99'")).firstMatch
        
        if addPresetButton.exists {
            addPresetButton.tap()
            
            // Check for purchase view elements
            let purchaseTitle = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Additional Presets'")).firstMatch
            XCTAssertTrue(purchaseTitle.waitForExistence(timeout: 3.0), "Purchase title should appear")
            
            let purchaseButton = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Purchase' OR label CONTAINS '$1.99'")).firstMatch
            XCTAssertTrue(purchaseButton.exists, "Purchase button should exist")
            
            let restoreButton = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Restore'")).firstMatch
            XCTAssertTrue(restoreButton.exists, "Restore button should exist")
            
            // Note: We don't actually test the purchase flow as that requires StoreKit sandbox
        }
    }
    
    @MainActor
    func testAccessibilityElements() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Test that key elements have accessibility labels
        let bankrollField = app.textFields["Bankroll"]
        XCTAssertTrue(bankrollField.exists, "Bankroll field should have accessibility label")
        
        let givenOddsField = app.textFields["Given Odds"]
        XCTAssertTrue(givenOddsField.exists, "Given odds field should have accessibility label")
        
        let actualOddsField = app.textFields["Actual Odds"]
        XCTAssertTrue(actualOddsField.exists, "Actual odds field should have accessibility label")
        
        let kellyMultiplierField = app.textFields["Kelly Multiplier"]
        XCTAssertTrue(kellyMultiplierField.exists, "Kelly multiplier field should have accessibility label")
        
        // Test button accessibility
        let oddsFormatButton = app.buttons.matching(NSPredicate(format: "label == 'American' OR label == 'Decimal'")).firstMatch
        XCTAssertTrue(oddsFormatButton.exists, "Odds format button should have accessibility label")
    }
    
    @MainActor
    func testRealTimeCalculation() throws {
        let app = XCUIApplication()
        app.launch()
        
        let bankrollField = app.textFields["Bankroll"]
        let givenOddsField = app.textFields["Given Odds"]
        let actualOddsField = app.textFields["Actual Odds"]
        
        // Input data progressively and verify updates
        bankrollField.tap()
        bankrollField.typeText("1000")
        
        givenOddsField.tap()
        givenOddsField.typeText("+150")
        
        actualOddsField.tap()
        actualOddsField.typeText("+120")
        
        // Should see real-time calculation updates
        let betDisplayElements = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '$'"))
        
        if betDisplayElements.count > 0 {
            let betDisplay = betDisplayElements.firstMatch
            XCTAssertTrue(betDisplay.waitForExistence(timeout: 2.0), "Bet calculation should appear")
            
            // Verify it's not zero (indicates calculation worked)
            let betText = betDisplay.label
            XCTAssertFalse(betText.contains("$0.00"), "Should show non-zero calculation with valid inputs")
        }
    }
    
    @MainActor
    func testDecimalOddsCalculation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Switch to decimal odds format
        let oddsFormatButton = app.buttons["American"]
        if oddsFormatButton.exists {
            oddsFormatButton.tap()
            
            let decimalButton = app.buttons["Decimal"]
            XCTAssertTrue(decimalButton.waitForExistence(timeout: 2.0))
            
            // Input decimal odds
            let bankrollField = app.textFields["Bankroll"]
            let givenOddsField = app.textFields["Given Odds"]
            let actualOddsField = app.textFields["Actual Odds"]
            
            bankrollField.tap()
            bankrollField.typeText("1000")
            
            givenOddsField.tap()
            givenOddsField.typeText("2.50")
            
            actualOddsField.tap()
            actualOddsField.typeText("2.20")
            
            // Verify calculation works with decimal odds
            let betDisplayElements = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '$'"))
            if betDisplayElements.count > 0 {
                let betDisplay = betDisplayElements.firstMatch
                XCTAssertTrue(betDisplay.waitForExistence(timeout: 2.0), "Bet calculation should work with decimal odds")
            }
        }
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
