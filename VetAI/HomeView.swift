import SwiftUI

struct HomeView: View {
    @Binding var diagnosisHistory: [DiagnosisRecord]
    @Binding var selectedTab: Int

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        Text("Welcome back, Olivia!")
                    }

                    if let lastRecord = diagnosisHistory.last {
                        Section {
                            VStack(alignment: .leading) {
                                Text(lastRecord.species)
                                Text(lastRecord.diagnosisResult)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    ForEach(diagnosisHistory) { record in
                        NavigationLink(destination: DiagnosisDetailView(record: record)) {
                            VStack(alignment: .leading) {
                                Text(record.species)
                                Text(record.diagnosisResult)
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
    HomeView(
        diagnosisHistory: .constant([
            DiagnosisRecord(
                species: "dog",
                symptoms: "lethargy",
                wbc: "5",
                rbc: "4",
                glucose: "100",
                diagnosisResult: "Possible anemia",
                confidence: "70%"
            )
        ]),
        selectedTab: .constant(0)
    )
}
