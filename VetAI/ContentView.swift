import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                        .foregroundColor(selectedTab == 0 ? Palette.primary : Palette.cyanDark.opacity(0.6))
                }
                .tag(0)

            NavigationStack {
                ScanView()
                    .navigationTitle("AI Diagnosis")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("AI Diagnosis", systemImage: "stethoscope")
                    .foregroundColor(selectedTab == 1 ? Palette.primary : Palette.cyanDark.opacity(0.6))
            }
            .tag(1)

            NavigationStack {
                ProfileView()
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Profile", systemImage: "person")
                    .foregroundColor(selectedTab == 2 ? Palette.primary : Palette.cyanDark.opacity(0.6))
            }
            .tag(2)
        }
        .tint(Palette.primary)
    }
}

#Preview {
    ContentView().environmentObject(AppState())
}
