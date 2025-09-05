import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @Binding var selectedTab: Int

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    Card {
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            if appState.ownerName.isEmpty {
                                Text("Welcome back!")
                                    .font(Typography.title)
                            } else {
                                Text("Welcome back, \(appState.ownerName)!")
                                    .font(Typography.title)
                            }
                            Text("Ready for your next diagnosis?")
                                .font(Typography.body)
                                .foregroundColor(.secondary)
                        }
                    }

                    if appState.diagnosisHistory.isEmpty {
                        Text("No diagnoses yet — run your first AI check.")
                            .font(Typography.body)
                            .foregroundColor(.secondary)
                    } else if let lastRecord = appState.diagnosisHistory.last {
                        NavigationLink(destination: ResultsView(record: binding(for: lastRecord))) {
                            Card {
                                SectionHeader("Recent Diagnosis")
                                VStack(alignment: .leading) {
                                    if let petID = lastRecord.petID,
                                       let pet = appState.pets.first(where: { $0.id == petID }) {
                                        Text(pet.name)
                                            .font(.headline)
                                    } else {
                                        Text(lastRecord.species.capitalized)
                                            .font(.headline)
                                    }
                                    Text(lastRecord.diagnosis)
                                        .foregroundColor(.primary)
                                    Text(lastRecord.date, style: .date)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }

                        NavigationLink("View All") {
                            HistoryView()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .frame(maxWidth: .infinity)
                    }

                    Button("Start New Diagnosis") {
                        selectedTab = 1
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .frame(maxWidth: .infinity)
                }
                .padding(Spacing.l)
            }
            .background(Palette.surfaceAlt)
            .navigationTitle("Home")
        }
    }

    private func binding(for record: DiagnosisRecord) -> Binding<DiagnosisRecord> {
        guard let index = appState.diagnosisHistory.firstIndex(where: { $0.id == record.id }) else {
            fatalError("Record not found")
        }
        return $appState.diagnosisHistory[index]
    }
}

#Preview {
    let appState = AppState()
    appState.diagnosisHistory = [
        DiagnosisRecord(species: "dog", diagnosis: "Possible anemia", triageLevel: "low", rationale: "", confidence: 0.7)
    ]
    return HomeView(selectedTab: .constant(0)).environmentObject(appState)
}
