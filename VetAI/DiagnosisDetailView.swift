import SwiftUI

struct DiagnosisDetailView: View {
    let record: DiagnosisRecord

    var body: some View {
        Form {
            Section(header: Text("Diagnosis")) {
                HStack { Text("Species"); Spacer(); Text(record.species) }
                HStack { Text("Result"); Spacer(); Text(record.result) }
                HStack { Text("Confidence"); Spacer(); Text(record.confidence, format: .percent) }
                HStack { Text("Date"); Spacer(); Text(record.date, style: .date) }
            }
        }
        .navigationTitle("Diagnosis Detail")
    }
}

#Preview {
    DiagnosisDetailView(record: DiagnosisRecord(species: "dog", result: "Possible anemia", confidence: 0.7))
}
