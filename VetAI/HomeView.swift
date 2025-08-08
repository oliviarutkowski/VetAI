import SwiftUI

struct HomeView: View {
    @Binding var diagnosisHistory: [DiagnosisRecord]

    var body: some View {
        NavigationStack {
            List(diagnosisHistory) { record in
                NavigationLink(destination: DiagnosisDetailView(record: record)) {
                    VStack(alignment: .leading) {
                        Text(record.species)
                        Text(record.diagnosisResult)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    HomeView(diagnosisHistory: .constant([
        DiagnosisRecord(species: "dog", symptoms: "lethargy", wbc: "5", rbc: "4", glucose: "100", diagnosisResult: "Possible anemia", confidence: "70%")
    ]))
}
