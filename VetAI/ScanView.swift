import SwiftUI
import UIKit

struct ScanView: View {
    @EnvironmentObject var appState: AppState
    @State private var species: String = "dog"
    @State private var symptoms: String = ""
    @State private var wbc: String = ""
    @State private var wbcIsUnknown: Bool = true
    @State private var rbc: String = ""
    @State private var rbcIsUnknown: Bool = true
    @State private var glucose: String = ""
    @State private var glucoseIsUnknown: Bool = true
    @State private var diagnosis: String = ""
    @State private var confidenceScore: Int = 0
    @State private var selectedPet: Pet? = nil

    var body: some View {
        ScrollView {
            Form {
                Picker("Species", selection: $species) {
                    Text("Dog").tag("dog")
                    Text("Cat").tag("cat")
                    Text("Other").tag("other")
                }

                Picker("Pet", selection: $selectedPet) {
                    Text("No specific pet").tag(nil as Pet?)
                    ForEach(appState.pets) { pet in
                        Text(pet.name).tag(Optional(pet))
                    }
                }

                Text("WBC (×10⁹/L)")
                    .font(.headline)
                Picker("", selection: $wbcIsUnknown) {
                    Text("Unknown").tag(true)
                    Text("Enter value").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: wbcIsUnknown) { isUnknown in
                    if isUnknown { wbc = "" }
                }
                if !wbcIsUnknown {
                    TextField("Enter value", text: $wbc)
                        .keyboardType(.decimalPad)
                }

                Text("RBC (×10¹²/L)")
                    .font(.headline)
                Picker("", selection: $rbcIsUnknown) {
                    Text("Unknown").tag(true)
                    Text("Enter value").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: rbcIsUnknown) { isUnknown in
                    if isUnknown { rbc = "" }
                }
                if !rbcIsUnknown {
                    TextField("Enter value", text: $rbc)
                        .keyboardType(.decimalPad)
                }

                Text("Glucose (mg/dL)")
                    .font(.headline)
                Picker("", selection: $glucoseIsUnknown) {
                    Text("Unknown").tag(true)
                    Text("Enter value").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: glucoseIsUnknown) { isUnknown in
                    if isUnknown { glucose = "" }
                }
                if !glucoseIsUnknown {
                    TextField("Enter value", text: $glucose)
                        .keyboardType(.decimalPad)
                }

                Text("What are your pet’s symptoms?")
                TextEditor(text: $symptoms)
                    .frame(minHeight: 100)

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
                    wbcIsUnknown = true
                    rbc = ""
                    rbcIsUnknown = true
                    glucose = ""
                    glucoseIsUnknown = true
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
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    ScanView().environmentObject(AppState())
}
