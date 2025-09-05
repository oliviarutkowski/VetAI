#if canImport(SwiftUI)
import SwiftUI

struct ScanView: View {
    @EnvironmentObject var appState: AppState
    @State private var species: String = "dog"
    @State private var wbc: String = ""
    @State private var wbcIsUnknown: Bool = true
    @State private var rbc: String = ""
    @State private var rbcIsUnknown: Bool = true
    @State private var glucose: String = ""
    @State private var glucoseIsUnknown: Bool = true
    @State private var symptomText: String = ""
    @State private var selectedPet: Pet? = nil

    @State private var isSubmitting = false
    @State private var triageResult: DiagnosisRecord? = nil
    @State private var errorMessage: String = ""
    @State private var showError = false

    var body: some View {
        Form {
            SectionHeader("Species & Pet")

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

            SectionHeader("Labs")

            Text("WBC")
                .font(Typography.section)
                .foregroundColor(.primary)
            Picker("", selection: $wbcIsUnknown) {
                Text("Unknown").tag(true)
                Text("Enter value").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: wbcIsUnknown) { _, isUnknown in
                if isUnknown { wbc = "" }
            }
            if !wbcIsUnknown {
                HStack {
                    TextField("e.g., 6.0", text: $wbc)
#if os(iOS)
                        .keyboardType(.decimalPad)
#endif
                        .font(Typography.body)
                    Spacer()
                    Text("×10⁹/L")
                        .font(Typography.caption)
                        .foregroundColor(.secondary)
                }
            }

            Text("RBC")
                .font(Typography.section)
                .foregroundColor(.primary)
            Picker("", selection: $rbcIsUnknown) {
                Text("Unknown").tag(true)
                Text("Enter value").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: rbcIsUnknown) { _, isUnknown in
                if isUnknown { rbc = "" }
            }
            if !rbcIsUnknown {
                HStack {
                    TextField("e.g., 6.0", text: $rbc)
#if os(iOS)
                        .keyboardType(.decimalPad)
#endif
                        .font(Typography.body)
                    Spacer()
                    Text("×10¹²/L")
                        .font(Typography.caption)
                        .foregroundColor(.secondary)
                }
            }

            Text("Glucose")
                .font(Typography.section)
                .foregroundColor(.primary)
            Picker("", selection: $glucoseIsUnknown) {
                Text("Unknown").tag(true)
                Text("Enter value").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: glucoseIsUnknown) { _, isUnknown in
                if isUnknown { glucose = "" }
            }
            if !glucoseIsUnknown {
                HStack {
                    TextField("e.g., 6.0", text: $glucose)
#if os(iOS)
                        .keyboardType(.decimalPad)
#endif
                        .font(Typography.body)
                    Spacer()
                    Text("mg/dL")
                        .font(Typography.caption)
                        .foregroundColor(.secondary)
                }
            }

            SectionHeader("Symptoms")
            TextEditor(text: $symptomText)
                .frame(height: 150)
                .border(Color.gray)

            Button("Analyze") {
                Task { await submit() }
            }
            .disabled(isSubmitting)
            .frame(maxWidth: .infinity)
            .buttonStyle(PrimaryButtonStyle())
        }
        .navigationDestination(item: $triageResult) { record in
            ResultsView(record: binding(for: record))
        }
        .alert(errorMessage, isPresented: $showError) {
            Button("Retry") { Task { await submit() } }
            Button("Cancel", role: .cancel) { }
        }
#if os(iOS)
        .scrollDismissesKeyboard(.interactively)
#endif
    }

    private func submit() async {
        isSubmitting = true
        defer { isSubmitting = false }

        let payload = CasePayload(
            pet: .init(name: selectedPet?.name ?? "", species: species, age: selectedPet?.age ?? 0),
            symptoms: symptomText.isEmpty ? [] : [.init(description: symptomText, durationDays: nil)],
            exposures: nil,
            wbc: Double(wbc),
            rbc: Double(rbc),
            glucose: Double(glucose)
        )

        do {
            let result = try await VetAIAPI().triage(payload)
            let record = DiagnosisRecord(
                species: species,
                diagnosis: result.diagnosis,
                triageLevel: result.triageLevel,
                rationale: result.rationale,
                confidence: result.confidence,
                differentials: result.differentials,
                notes: nil,
                date: result.createdAt ?? Date(),
                petID: selectedPet?.id
            )
            appState.diagnosisHistory.append(record)
            triageResult = record
            resetForm()
        } catch {
            errorMessage = "Submission failed."
            showError = true
        }
    }

    private func resetForm() {
        species = "dog"
        wbc = ""
        wbcIsUnknown = true
        rbc = ""
        rbcIsUnknown = true
        glucose = ""
        glucoseIsUnknown = true
        symptomText = ""
        selectedPet = nil
    }

    private func binding(for record: DiagnosisRecord) -> Binding<DiagnosisRecord> {
        guard let index = appState.diagnosisHistory.firstIndex(where: { $0.id == record.id }) else {
            fatalError("Record not found")
        }
        return $appState.diagnosisHistory[index]
    }
}

#if DEBUG
#Preview {
    ScanView().environmentObject(AppState())
}
#endif
#endif
