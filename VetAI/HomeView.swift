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
                            Text(appState.ownerName.isEmpty ? "Welcome back!" : "Welcome back, \(appState.ownerName)!")
                                .font(Typography.title)
                            Text("Ready for your next diagnosis?")
                                .font(Typography.body)
                                .foregroundColor(.secondary)
                        }
                    }

                    if let lastRecord = appState.diagnosisHistory.last {
                        NavigationLink(destination: DiagnosisDetailView(record: lastRecord)) {
                            Card {
                                SectionHeader(title: "Recent Diagnosis")
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
                    }

                    Button("Start New Diagnosis") {
                        selectedTab = 1
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .frame(maxWidth: .infinity)

                    if appState.diagnosisHistory.count > 1 {
                        VStack(spacing: Spacing.md) {
                            ForEach(Array(appState.diagnosisHistory.dropLast())) { record in
                                NavigationLink(destination: DiagnosisDetailView(record: record)) {
                                    Card {
                                        VStack(alignment: .leading) {
                                            if let petID = record.petID,
                                               let pet = appState.pets.first(where: { $0.id == petID }) {
                                                Text(pet.name)
                                                    .font(.headline)
                                            } else {
                                                Text(record.species.capitalized)
                                                    .font(.headline)
                                            }
                                            Text(record.diagnosis)
                                            Text(record.date, style: .date)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(Spacing.l)
            }
            .background(Palette.surfaceAlt)
            .navigationTitle("History")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
    }
}

#Preview {
    let appState = AppState()
    appState.diagnosisHistory = [
        DiagnosisRecord(
            species: "dog",
            diagnosis: "Possible anemia",
            confidenceScore: 70
        )
    ]
    return HomeView(selectedTab: .constant(0)).environmentObject(appState)
}

