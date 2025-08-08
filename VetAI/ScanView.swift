import SwiftUI

struct ScanView: View {
    @Binding var diagnosisHistory: [DiagnosisRecord]
    @State private var species: String = "dog"
    @State private var symptoms: String = ""
    @State private var wbc: String = ""
    @State private var rbc: String = ""
    @State private var glucose: String = ""
    @State private var diagnosis: String = ""
    @State private var confidence: String = ""

    var body: some View {
        Form {
            Picker("Species", selection: $species) {
                Text("dog").tag("dog")
                Text("cat").tag("cat")
                Text("other").tag("other")
            }

            TextEditor(text: $symptoms)
                .frame(minHeight: 100)

            TextField("WBC Count", text: $wbc)
                .keyboardType(.decimalPad)

            TextField("RBC Count", text: $rbc)
                .keyboardType(.decimalPad)

            TextField("Glucose", text: $glucose)
                .keyboardType(.decimalPad)

            Button("Analyze") {
                if symptoms.lowercased().contains("lethargy") {
                    diagnosis = "Possible anemia"
                    confidence = "70%"
                } else {
                    diagnosis = "No specific diagnosis"
                    confidence = "N/A"
                }

                let record = DiagnosisRecord(
                    species: species,
                    symptoms: symptoms,
                    wbc: wbc,
                    rbc: rbc,
                    glucose: glucose,
                    diagnosisResult: diagnosis,
                    confidence: confidence
                )
                diagnosisHistory.append(record)
            }

            if !diagnosis.isEmpty {
                VStack(alignment: .leading) {
                    Text("Diagnosis: \(diagnosis)")
                    Text("Confidence: \(confidence)")
                }
            }
        }
    }
}

#Preview {
    ScanView(diagnosisHistory: .constant([]))
}
