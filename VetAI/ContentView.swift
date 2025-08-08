import SwiftUI

struct ContentView: View {
    @State private var diagnosisHistory: [DiagnosisRecord] = []

    var body: some View {
        TabView {
            HomeView(diagnosisHistory: $diagnosisHistory)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            ScanView(diagnosisHistory: $diagnosisHistory)
                .tabItem {
                    Label("AI Diagnosis", systemImage: "stethoscope")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
