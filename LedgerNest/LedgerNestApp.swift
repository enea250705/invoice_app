//
//  LedgerNestApp.swift
//  LedgerNest
//
//  Main app entry point with SwiftData setup and onboarding flow
//

import SwiftUI
import SwiftData

@main
struct LedgerNestApp: App {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Property.self,
            Invoice.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Fallback to in-memory storage if persistent storage fails
            print("Failed to create persistent ModelContainer: \(error)")
            print("Falling back to in-memory storage")
            let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            do {
                return try ModelContainer(for: schema, configurations: [fallbackConfig])
            } catch {
                // Last resort: fatal error if even in-memory fails
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            if onboardingViewModel.hasCompletedOnboarding {
                MainView()
                    .modelContainer(sharedModelContainer)
            } else {
                OnboardingView(viewModel: onboardingViewModel)
            }
        }
    }
}
