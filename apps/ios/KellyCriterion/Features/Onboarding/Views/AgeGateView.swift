//
//  AgeGateView.swift
//  KellyCriterion
//
//  Created for App Store compliance - Age verification and gambling disclaimer
//

import SwiftUI

struct AgeGateView: View {
    
    // MARK: - Properties
    @Binding var hasAcceptedAgeGate: Bool
    @State private var age: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private let minimumAge = 17 // Apple's 17+ rating requirement
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Header
            headerView
            
            // Age verification
            ageVerificationView
            
            // Compact disclaimer
            compactDisclaimerView
            
            // Action buttons
            actionButtonsView
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color(.systemBackground))
        .alert("Age Verification", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)
            
            Text("Age Verification Required")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Kelly Stakes - Bet Calculator")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var ageVerificationView: some View {
        VStack(spacing: 16) {
            Text("Please confirm your age")
                .font(.headline)
            
            HStack {
                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 80)
                    .multilineTextAlignment(.center)
                
                Text("years old")
                    .foregroundColor(.secondary)
            }
            
            Text("Must be \(minimumAge)+ to use this app")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var compactDisclaimerView: some View {
        VStack(spacing: 16) {
            // Main disclaimer box
            VStack(spacing: 12) {
                Label("Important Notice", systemImage: "info.circle.fill")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text("Kelly Stakes is a **calculator tool only**. We do NOT facilitate real money gambling.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
                Divider()
                
                VStack(spacing: 8) {
                    Text("By continuing, you confirm that:")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Label("You are \(minimumAge) years or older", systemImage: "checkmark.circle.fill")
                        Label("You'll use this as a calculator only", systemImage: "checkmark.circle.fill")
                        Label("You'll gamble responsibly if you choose to bet", systemImage: "checkmark.circle.fill")
                        Label("You accept our terms and privacy policy", systemImage: "checkmark.circle.fill")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Gambling help
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.orange)
                    Text("Problem Gambling: 1-800-522-4700")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            .padding(16)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            // Accept button
            Button(action: {
                verifyAndAccept()
            }) {
                Text("I Accept & Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(age.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(12)
            }
            .disabled(age.isEmpty)
            
            // Links row
            HStack(spacing: 20) {
                Link("Privacy Policy", destination: URL(string: "https://kelly-criterion-website.vercel.app/privacy")!)
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Text("•")
                    .foregroundColor(.secondary)
                
                Link("Terms of Service", destination: URL(string: "https://kelly-criterion-website.vercel.app/terms")!)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
    }
    
    // MARK: - Methods
    
    private func verifyAndAccept() {
        guard let userAge = Int(age) else {
            alertMessage = "Please enter a valid age"
            showingAlert = true
            return
        }
        
        if userAge >= minimumAge {
            // Save acceptance to UserDefaults
            UserDefaults.standard.set(true, forKey: "hasAcceptedAgeGate")
            UserDefaults.standard.set(Date(), forKey: "ageGateAcceptedDate")
            hasAcceptedAgeGate = true
        } else {
            alertMessage = "You must be at least \(minimumAge) years old to use this app"
            showingAlert = true
        }
    }
}

// MARK: - Preview
#Preview {
    AgeGateView(hasAcceptedAgeGate: .constant(false))
}