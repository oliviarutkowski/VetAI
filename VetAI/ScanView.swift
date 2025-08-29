import SwiftUI

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
#if os(iOS)
    @FocusState private var isSymptomsFocused: Bool
#endif

    var body: some View {
        Form {
            SectionHeader(title: "Species")

            Picker("Species", selection: $species) {
                Text("Dog").tag("dog")
                Text("Cat").tag("cat")
                Text("Other").tag("other")
            }

            SectionHeader(title: "Pet")

            Picker("Pet", selection: $selectedPet) {
                Text("No specific pet").tag(nil as Pet?)
                ForEach(appState.pets) { pet in
                    Text(pet.name).tag(Optional(pet))
                }
            }

            SectionHeader(title: "Labs")

              Text("WBC (×10⁹/L)")
                  .font(Typography.section)
                  .foregroundColor(.primary)
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
#if os(iOS)
                    .keyboardType(.decimalPad)
#endif
                    .font(Typography.body)
            }

              Text("RBC (×10¹²/L)")
                  .font(Typography.section)
                  .foregroundColor(.primary)
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
#if os(iOS)
                    .keyboardType(.decimalPad)
#endif
                    .font(Typography.body)
            }

              Text("Glucose (mg/dL)")
                  .font(Typography.section)
                  .foregroundColor(.primary)
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
#if os(iOS)
                    .keyboardType(.decimalPad)
#endif
                    .font(Typography.body)
            }

            SectionHeader(title: "Symptoms")

            TextEditor(text: $symptoms)
                .font(Typography.body)
#if os(iOS)
                .focused($isSymptomsFocused)
#endif
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
#if os(iOS)
                isSymptomsFocused = false
#endif
            }
            .buttonStyle(PrimaryButtonStyle())

            if !diagnosis.isEmpty {
                VStack(alignment: .leading) {
                    Text("Diagnosis: \(diagnosis)")
                        .font(Typography.body)
                    Text("Confidence: \(confidenceScore)%")
                        .font(Typography.body)
                }
            }
        }
#if os(iOS)
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isSymptomsFocused = false
                }
            }
        }
#endif
    }
}

#Preview {
    ScanView().environmentObject(AppState())
}
