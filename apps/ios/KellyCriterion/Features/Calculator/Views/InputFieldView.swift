//
//  InputFieldView.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import SwiftUI

struct InputFieldView: View {
    
    // MARK: - Properties
    let title: String
    let placeholder: String
    @Binding var text: String
    let errorMessage: String?
    let keyboardType: UIKeyboardType
    let prefix: String?
    let suffix: String?
    let isRequired: Bool
    let maxLength: Int?
    
    @FocusState private var isFocused: Bool
    
    // MARK: - Initialization
    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        errorMessage: String? = nil,
        keyboardType: UIKeyboardType = .default,
        prefix: String? = nil,
        suffix: String? = nil,
        isRequired: Bool = true,
        maxLength: Int? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.errorMessage = errorMessage
        self.keyboardType = keyboardType
        self.prefix = prefix
        self.suffix = suffix
        self.isRequired = isRequired
        self.maxLength = maxLength
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            // Input field
            HStack(spacing: 8) {
                // Prefix
                if let prefix = prefix {
                    Text(prefix)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                }
                
                // Text field
                TextField(placeholder, text: $text)
                    .font(.body)
                    .keyboardType(keyboardType)
                    .focused($isFocused)
                    .onChange(of: text) { _, newValue in
                        // Apply max length if specified
                        if let maxLength = maxLength, newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
                    .submitLabel(.done)
                    .onSubmit {
                        isFocused = false
                    }
                
                // Suffix
                if let suffix = suffix {
                    Text(suffix)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                }
                
                // Clear button
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                        isFocused = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .padding(.trailing, 4)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .animation(.easeInOut(duration: 0.2), value: hasError)
            
        }
    }
    
    // MARK: - Computed Properties
    private var hasError: Bool {
        return errorMessage != nil
    }
    
    private var borderColor: Color {
        if hasError {
            return .red
        } else if isFocused {
            return .blue
        } else {
            return .clear
        }
    }
}

// MARK: - Convenience Initializers
extension InputFieldView {
    
    /// Currency input field
    /// - Parameters:
    ///   - title: Field title
    ///   - text: Binding to text value
    ///   - errorMessage: Optional error message
    /// - Returns: InputFieldView configured for currency
    static func currency(
        title: String,
        text: Binding<String>,
        errorMessage: String? = nil
    ) -> InputFieldView {
        return InputFieldView(
            title: title,
            placeholder: "0.00",
            text: text,
            errorMessage: errorMessage,
            keyboardType: .decimalPad,
            prefix: "$",
            isRequired: false, // Made non-required per user request
            maxLength: 10
        )
    }
    
    /// Enhanced odds input field with quick buttons
    /// - Parameters:
    ///   - title: Field title
    ///   - text: Binding to text value
    ///   - errorMessage: Optional error message
    ///   - oddsFormat: Current odds format
    /// - Returns: OddsInputView with quick action buttons
    static func odds(
        title: String,
        text: Binding<String>,
        errorMessage: String? = nil,
        oddsFormat: AppConstants.OddsFormat
    ) -> OddsInputView {
        return OddsInputView(
            title: title,
            text: text,
            errorMessage: errorMessage,
            oddsFormat: oddsFormat
        )
    }
    
    /// Percentage input field
    /// - Parameters:
    ///   - title: Field title
    ///   - text: Binding to text value
    ///   - errorMessage: Optional error message
    /// - Returns: InputFieldView configured for percentage
    static func percentage(
        title: String,
        text: Binding<String>,
        errorMessage: String? = nil
    ) -> InputFieldView {
        return InputFieldView(
            title: title,
            placeholder: "0.25",
            text: text,
            errorMessage: errorMessage,
            keyboardType: .decimalPad,
            isRequired: false, // Made non-required per user request
            maxLength: 5
        )
    }
    
    /// Text input field
    /// - Parameters:
    ///   - title: Field title
    ///   - text: Binding to text value
    ///   - errorMessage: Optional error message
    ///   - maxLength: Maximum text length
    /// - Returns: InputFieldView configured for text
    static func text(
        title: String,
        text: Binding<String>,
        errorMessage: String? = nil,
        maxLength: Int = 30
    ) -> InputFieldView {
        return InputFieldView(
            title: title,
            placeholder: "Enter \(title.lowercased())",
            text: text,
            errorMessage: errorMessage,
            keyboardType: .default,
            maxLength: maxLength
        )
    }
}

// MARK: - Enhanced Odds Input View
struct OddsInputView: View {
    let title: String
    @Binding var text: String
    let errorMessage: String?
    let oddsFormat: AppConstants.OddsFormat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            // Input field
            TextField(oddsFormat == .american ? "+150" : "2.50", text: $text)
                .font(.body)
                .keyboardType(.numbersAndPunctuation)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(errorMessage != nil ? .red : .clear, lineWidth: 1.5)
                )
            
            // +/- symbol buttons underneath (only for American odds)
            if oddsFormat == .american {
                HStack(spacing: 8) {
                    // Plus button
                    Button(action: {
                        if !text.hasPrefix("+") && !text.hasPrefix("-") && !text.isEmpty {
                            text = "+" + text
                        } else if text.isEmpty {
                            text = "+"
                        }
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }) {
                        Text("+")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .frame(width: 44, height: 32)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                    }
                    .accessibilityLabel("Add plus sign")
                    
                    // Minus button
                    Button(action: {
                        if !text.hasPrefix("-") && !text.hasPrefix("+") && !text.isEmpty {
                            text = "-" + text
                        } else if text.isEmpty {
                            text = "-"
                        }
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }) {
                        Text("−")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(width: 44, height: 32)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                    }
                    .accessibilityLabel("Add minus sign")
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 24) {
        InputFieldView.currency(
            title: "Bankroll",
            text: .constant("1000"),
            errorMessage: nil
        )
        
        OddsInputView(
            title: "Given Odds",
            text: .constant("+150"),
            errorMessage: nil,
            oddsFormat: .american
        )
        
        InputFieldView.percentage(
            title: "Kelly Multiplier",
            text: .constant("0.25"),
            errorMessage: nil
        )
        
        InputFieldView.text(
            title: "Preset Name",
            text: .constant("My Preset"),
            errorMessage: nil
        )
    }
    .padding()
}