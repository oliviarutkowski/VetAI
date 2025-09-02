import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                      Label("Home", systemImage: "house")
                          .foregroundColor(selectedTab == 0 ? .primary : .secondary)
                }
                .tag(0)

            NavigationStack {
                SymptomFormView()
                    .navigationTitle("Triage")
                    #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                    #endif
            }
            .tabItem {
                  Label("Triage", systemImage: "list.bullet")
                      .foregroundColor(selectedTab == 1 ? .primary : .secondary)
            }
            .tag(1)

            NavigationStack {
                ScanView()
                    .navigationTitle("AI Diagnosis")
                    #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                    #endif
            }
            .tabItem {
                  Label("AI Diagnosis", systemImage: "stethoscope")
                      .foregroundColor(selectedTab == 2 ? .primary : .secondary)
            }
            .tag(2)

            NavigationStack {
                ProfileView()
                    .navigationTitle("Profile")
                    #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                    #endif
            }
            .tabItem {
                  Label("Profile", systemImage: "person")
                      .foregroundColor(selectedTab == 3 ? .primary : .secondary)
            }
            .tag(3)
        }
        .tint(Palette.primary)
    }
}

#Preview {
    ContentView().environmentObject(AppState())
}
