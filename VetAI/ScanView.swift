import SwiftUI

struct ScanView: View {
    @EnvironmentObject var appState: AppState
    @State private var species: String = "dog"
    @State private var symptoms: String = ""
    @State private var wbc: String = ""
    @State private var rbc: String = ""
    @State private var glucose: String = ""
    @State private var diagnosis: String = ""
    @State private var confidenceScore: Int = 0
    @State private var selectedPet: Pet? = nil

    var body: some View {
        Form {
            Picker("Species", selection: $species) {
                Text("dog").tag("dog")
                Text("cat").tag("cat")
                Text("other").tag("other")
            }

            Picker("Pet", selection: $selectedPet) {
                Text("No specific pet").tag(nil as Pet?)
                ForEach(appState.pets) { pet in
                    Text(pet.name).tag(Optional(pet))
                }
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
                    confidenceScore = 70
                } else {
                    diagnosis = "No specific diagnosis"
                    confidenceScore = 0
                }

                let record = DiagnosisRecord(
                    species: species,
                    diagnosis: diagnosis,
                    confidenceScore: confidenceScore,
                    date: Date(),
                    petID: selectedPet?.id
                )
                appState.diagnosisHistory.append(record)

                species = "dog"
                symptoms = ""
                wbc = ""
                rbc = ""
                glucose = ""
                selectedPet = nil
            }

            if !diagnosis.isEmpty {
                VStack(alignment: .leading) {
                    Text("Diagnosis: \(diagnosis)")
                    Text("Confidence: \(confidenceScore)%")
                }
            }
        }
    }
}

#Preview {
    ScanView().environmentObject(AppState())
}
