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
    @State private var selectedPet: Pet? = nil
    @State private var isSubmitting = false
    @State private var triageResult: TriageResult? = nil
    @State private var showError = false
    @State private var errorMessage: String? = nil
#if os(iOS)
    @FocusState private var isSymptomsFocused: Bool
#endif

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
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: appState.pets)

            SectionHeader("Labs")

            Text("WBC")
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
            .onChange(of: rbcIsUnknown) { isUnknown in
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
            .onChange(of: glucoseIsUnknown) { isUnknown in
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

            TextEditor(text: $symptoms)
                .font(Typography.body)
#if os(iOS)
                .focused($isSymptomsFocused)
#endif
                .frame(minHeight: 100)

            Button(action: { Task { await submit() } }) {
                if isSubmitting {
                    ProgressView()
                } else {
                    Text("Submit Symptoms")
                }
            }
            .disabled(isSubmitting)
            .frame(maxWidth: .infinity)
            .buttonStyle(PrimaryButtonStyle())

            NavigationLink(destination: ResultsView(result: triageResult!), isActive: Binding(
                get: { triageResult != nil },
                set: { if !$0 { triageResult = nil } }
            )) { EmptyView() }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: triageResult)
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
        .alert("Error", isPresented: $showError) {
            Button("Retry") { Task { await submit() } }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "Unknown error")
        }
    }
    
    private func submit() async {
        isSubmitting = true
        defer { isSubmitting = false }
        let payload = CasePayload(
            petProfile: PetProfile(species: species, name: selectedPet?.name),
            symptoms: [Symptom(text: symptoms)],
            exposuresRisks: ExposuresRisks(medications: nil, toxins: nil),
            wbc: Double(wbc),
            rbc: Double(rbc),
            glucose: Double(glucose)
        )
        let userMsg = PromptBuilder.user(from: payload)
        for attempt in 0..<2 {
            do {
                let data = try await LLMClient().send(system: PromptBuilder.system, user: userMsg)
                let result = try JSONDecoder().decode(TriageResult.self, from: data)
                try TriageResultValidator.validate(result)
                triageResult = result
                return
            } catch {
                VetLog.e("Submission failed: \(error.localizedDescription)")
                if attempt == 1 {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

#Preview {
    ScanView().environmentObject(AppState())
}
