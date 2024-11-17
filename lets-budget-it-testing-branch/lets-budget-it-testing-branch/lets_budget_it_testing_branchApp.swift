//
//  lets_budget_it_testing_branchApp.swift
//  lets-budget-it-testing-branch
//
//  Created by user267420 on 11/17/24.
//

import SwiftUI
import SwiftData

@main
struct lets_budget_it_testing_branchApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LaunchScreenView() // Set LaunchScreenView as the initial view
        }
        .modelContainer(sharedModelContainer)
    }
}
