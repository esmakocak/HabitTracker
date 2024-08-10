//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Esma Koçak on 10.08.2024.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
