//
//  SettingsView.swift
//  KellyCriterion
//
//  Settings and About section with Privacy Policy link
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasAcceptedAgeGate") private var hasAcceptedAgeGate = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                // App Info Section
                Section {
                    HStack {
                        Label("Kelly Stakes", systemImage: "percent")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("Version 1.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Category", systemImage: "square.grid.2x2")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("Finance")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("App Information")
                }
                
                // Legal Section
                Section {
                    Link(destination: URL(string: "https://kelly-criterion-website.vercel.app/privacy")!) {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                            .foregroundColor(.blue)
                    }
                    
                    Link(destination: URL(string: "https://kelly-criterion-website.vercel.app/terms")!) {
                        Label("Terms of Service", systemImage: "doc.text")
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        // Show age gate again
                        hasAcceptedAgeGate = false
                        dismiss()
                    }) {
                        Label("View Age Disclaimer", systemImage: "exclamationmark.triangle")
                            .foregroundColor(.orange)
                    }
                } header: {
                    Text("Legal")
                } footer: {
                    Text("Kelly Stakes is a calculator tool only. We do not facilitate real money gambling.")
                        .font(.caption)
                }
                
                // Support Section
                Section {
                    Link(destination: URL(string: "mailto:kellystakesapp@gmail.com")!) {
                        Label("Contact Support", systemImage: "envelope")
                            .foregroundColor(.blue)
                    }
                    
                    Link(destination: URL(string: "https://kelly-criterion-website.vercel.app/help")!) {
                        Label("Help Center", systemImage: "questionmark.circle")
                            .foregroundColor(.blue)
                    }
                    
                    Link(destination: URL(string: "https://apps.apple.com/app/kelly-stakes/id123456789")!) {
                        Label("Rate on App Store", systemImage: "star")
                            .foregroundColor(.blue)
                    }
                } header: {
                    Text("Support")
                }
                
                // Responsible Gambling Section
                Section {
                    Link(destination: URL(string: "https://www.ncpgambling.org")!) {
                        VStack(alignment: .leading, spacing: 4) {
                            Label("Problem Gambling Help", systemImage: "phone.fill")
                                .foregroundColor(.red)
                            Text("1-800-522-4700")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Link(destination: URL(string: "https://www.begambleaware.org")!) {
                        Label("BeGambleAware", systemImage: "info.circle")
                            .foregroundColor(.blue)
                    }
                } header: {
                    Text("Responsible Gambling")
                } footer: {
                    Text("If you or someone you know has a gambling problem, help is available.")
                        .font(.caption)
                }
                
                // About Section
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About Kelly Stakes")
                            .font(.headline)
                        Text("Kelly Stakes helps you calculate optimal bet sizes using the Kelly Criterion, a mathematical formula for bankroll management. This app is designed for educational purposes and strategic planning only.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                } footer: {
                    VStack(spacing: 8) {
                        Text("© 2025 Kelly Stakes. All rights reserved.")
                        Text("Made with ❤️ for responsible bettors")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}