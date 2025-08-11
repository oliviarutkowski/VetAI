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

                    if let lastRecord = appState.diagnosisHistory.last {
                        Section {
                            VStack(alignment: .leading) {
                                Text(lastRecord.species.capitalized)
                                    .font(.headline)
                                Text(lastRecord.result)
                                Text(lastRecord.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    ForEach(appState.diagnosisHistory) { record in
                        NavigationLink(destination: DiagnosisDetailView(record: record)) {
                            VStack(alignment: .leading) {
                                Text(record.species.capitalized)
                                    .font(.headline)
                                Text(record.result)
                                Text(record.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                Button("Start New Diagnosis") {
                    selectedTab = 1
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    let appState = AppState()
    appState.diagnosisHistory = [
        DiagnosisRecord(
            species: "dog",
            result: "Possible anemia",
            confidence: 0.7
        )
    ]
    return HomeView(selectedTab: .constant(0)).environmentObject(appState)
}
