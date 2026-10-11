//
//  View+Extensions.swift
//  KellyCriterion
//
//  Created by Michael Chen on 7/16/25.
//

import SwiftUI

extension View {
    
    /// Apply conditional modifier
    /// - Parameters:
    ///   - condition: Condition to check
    ///   - modifier: Modifier to apply if condition is true
    /// - Returns: Modified view
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Apply conditional modifier with else clause
    /// - Parameters:
    ///   - condition: Condition to check
    ///   - ifTransform: Modifier to apply if condition is true
    ///   - elseTransform: Modifier to apply if condition is false
    /// - Returns: Modified view
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
    
    /// Apply modifier if optional value is not nil
    /// - Parameters:
    ///   - value: Optional value to check
    ///   - modifier: Modifier to apply if value is not nil
    /// - Returns: Modified view
    @ViewBuilder
    func ifLet<Value, Content: View>(_ value: Value?, transform: (Self, Value) -> Content) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
    
    /// Add rounded corners with border
    /// - Parameters:
    ///   - radius: Corner radius
    ///   - borderColor: Border color
    ///   - borderWidth: Border width
    /// - Returns: Modified view
    func roundedBorder(radius: CGFloat = 8, borderColor: Color = .gray, borderWidth: CGFloat = 1) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
    }
    
    /// Add shadow with default values
    /// - Parameters:
    ///   - color: Shadow color
    ///   - radius: Shadow radius
    ///   - x: X offset
    ///   - y: Y offset
    /// - Returns: Modified view
    func defaultShadow(color: Color = .black.opacity(0.1), radius: CGFloat = 2, x: CGFloat = 0, y: CGFloat = 1) -> some View {
        self.shadow(color: color, radius: radius, x: x, y: y)
    }
    
    /// Add card-like appearance
    /// - Parameters:
    ///   - cornerRadius: Corner radius
    ///   - shadowRadius: Shadow radius
    ///   - backgroundColor: Background color
    /// - Returns: Modified view
    func cardStyle(cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 4, backgroundColor: Color = .white) -> some View {
        self
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: shadowRadius, x: 0, y: 2)
    }
    
    /// Add button-like appearance
    /// - Parameters:
    ///   - backgroundColor: Background color
    ///   - foregroundColor: Foreground color
    ///   - cornerRadius: Corner radius
    ///   - padding: Internal padding
    /// - Returns: Modified view
    func buttonStyle(
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        cornerRadius: CGFloat = 8,
        padding: EdgeInsets = EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
    ) -> some View {
        self
            .foregroundColor(foregroundColor)
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }
    
    /// Add input field appearance
    /// - Parameters:
    ///   - backgroundColor: Background color
    ///   - borderColor: Border color
    ///   - cornerRadius: Corner radius
    ///   - padding: Internal padding
    /// - Returns: Modified view
    func inputFieldStyle(
        backgroundColor: Color = .white,
        borderColor: Color = .gray.opacity(0.3),
        cornerRadius: CGFloat = 8,
        padding: EdgeInsets = EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
    ) -> some View {
        self
            .padding(padding)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
    
    /// Add error state styling
    /// - Parameter isError: Whether to show error state
    /// - Returns: Modified view
    func errorState(_ isError: Bool) -> some View {
        self
            .if(isError) { view in
                view.overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.red, lineWidth: 2)
                )
            }
    }
    
    /// Add accessibility improvements
    /// - Parameters:
    ///   - label: Accessibility label
    ///   - hint: Accessibility hint
    ///   - traits: Accessibility traits
    /// - Returns: Modified view
    func accessibilityImproved(
        label: String? = nil,
        hint: String? = nil,
        traits: AccessibilityTraits = []
    ) -> some View {
        self
            .ifLet(label) { view, label in
                view.accessibilityLabel(label)
            }
            .ifLet(hint) { view, hint in
                view.accessibilityHint(hint)
            }
            .if(!traits.isEmpty) { view in
                view.accessibilityAddTraits(traits)
            }
    }
    
    /// Add haptic feedback on tap
    /// - Parameter style: Haptic feedback style
    /// - Returns: Modified view
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: style)
            impactFeedback.impactOccurred()
        }
    }
    
    /// Add loading state overlay
    /// - Parameter isLoading: Whether to show loading state
    /// - Returns: Modified view
    func loadingOverlay(_ isLoading: Bool) -> some View {
        self
            .overlay(
                Group {
                    if isLoading {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.1))
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            )
                    }
                }
            )
    }
    
    /// Hide keyboard when tapped
    /// - Returns: Modified view
    func hideKeyboard() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}