import SwiftUI

struct ContentView: View {
    @State private var diagnosisHistory: [DiagnosisRecord] = []
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(diagnosisHistory: $diagnosisHistory, selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            ScanView(diagnosisHistory: $diagnosisHistory)
                .tabItem {
                    Label("AI Diagnosis", systemImage: "stethoscope")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
