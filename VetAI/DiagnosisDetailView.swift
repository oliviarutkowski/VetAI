import SwiftUI

struct DiagnosisDetailView: View {
    let record: DiagnosisRecord

    var body: some View {
        Form {
            Section(header: Text("Inputs")) {
                HStack { Text("Species"); Spacer(); Text(record.species) }
                HStack { Text("Symptoms"); Spacer(); Text(record.symptoms) }
                HStack { Text("WBC"); Spacer(); Text(record.wbc) }
                HStack { Text("RBC"); Spacer(); Text(record.rbc) }
                HStack { Text("Glucose"); Spacer(); Text(record.glucose) }
            }
            Section(header: Text("Diagnosis")) {
                HStack { Text("Result"); Spacer(); Text(record.diagnosisResult) }
                HStack { Text("Confidence"); Spacer(); Text(record.confidence) }
            }
        }
        .navigationTitle("Diagnosis Detail")
    }
}

#Preview {
    DiagnosisDetailView(record: DiagnosisRecord(species: "dog", symptoms: "lethargy", wbc: "5", rbc: "4", glucose: "100", diagnosisResult: "Possible anemia", confidence: "70%"))
}
