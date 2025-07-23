//
//  VetAIApp.swift
//  VetAI
//
//  Created by Olivia on 7/23/25.
//

import SwiftUI

@main
struct VetAIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
