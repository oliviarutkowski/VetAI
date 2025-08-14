import SwiftUI

@main
struct VetAIApp: App {
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .tint(Palette.primary)
        }
    }
}
