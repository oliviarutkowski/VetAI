import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @Binding var selectedTab: Int

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        Text(appState.ownerName.isEmpty ? "Welcome back!" : "Welcome back, \(appState.ownerName)!")
                    }
                    .listRowBackground(Color.clear)
                    .card()

                    if let lastRecord = appState.diagnosisHistory.last {
                        Section {
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
                                    .foregroundColor(Palette.blueAccent)
                                Text(lastRecord.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .listRowBackground(Color.clear)
                        .card()
                    }

                    ForEach(appState.diagnosisHistory) { record in
                        NavigationLink(destination: DiagnosisDetailView(record: record)) {
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
                        .listRowBackground(Color.clear)
                        .card()
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Palette.surfaceAlt)

                Button("Start New Diagnosis") {
                    selectedTab = 1
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding()
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
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
