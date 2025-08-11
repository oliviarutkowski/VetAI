import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @Binding var selectedTab: Int

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        Text("Welcome back, Olivia!")
                    }

                    if let lastRecord = appState.diagnosisHistory.last {
                        Section {
                            VStack(alignment: .leading) {
                                Text(lastRecord.species)
                                Text(lastRecord.result)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    ForEach(appState.diagnosisHistory) { record in
                        NavigationLink(destination: DiagnosisDetailView(record: record)) {
                            VStack(alignment: .leading) {
                                Text(record.species)
                                Text(record.result)
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
            symptoms: "lethargy",
            wbc: "5",
            rbc: "4",
            glucose: "100",
            result: "Possible anemia",
            confidence: "70%"
        )
    ]
    return HomeView(selectedTab: .constant(0)).environmentObject(appState)
}
