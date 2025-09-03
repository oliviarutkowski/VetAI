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
    @State private var diagnosis: String = ""
    @State private var confidenceScore: Int = 0
    @State private var selectedPet: Pet? = nil

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

            TriageSection()

            Button("Analyze") {
                Task {
                    let payload = CasePayload(
                        pet: PetProfile(
                            name: selectedPet?.name ?? "",
                            species: species,
                            age: selectedPet?.age ?? 0
                        ),
                        symptoms: [],
                        exposures: nil
                    )
                    do {
                        let result = try await LLMClient.shared.triage(payload)
                        let diff = result.differentials?.first
                        await MainActor.run {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                diagnosis = diff?.condition ?? "No specific diagnosis"
                                confidenceScore = diff?.confidencePct ?? 0

                                let record = DiagnosisRecord(
                                    species: species,
                                    diagnosis: diagnosis,
                                    confidenceScore: confidenceScore,
                                    date: Date(),
                                    petID: selectedPet?.id
                                )
                                appState.diagnosisHistory.append(record)

                                species = "dog"
                                wbc = ""
                                wbcIsUnknown = true
                                rbc = ""
                                rbcIsUnknown = true
                                glucose = ""
                                glucoseIsUnknown = true
                                selectedPet = nil
                            }
#if os(iOS)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
#endif
                        }
                    } catch {
                        VetLog.e("Diagnostic error: \(error)")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(PrimaryButtonStyle())

            if !diagnosis.isEmpty {
                Card {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text(diagnosis)
                            .font(Typography.section)
                        ProgressView("Confidence", value: Double(confidenceScore), total: 100)
                        Text("Saved to history")
                            .font(Typography.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
#if os(iOS)
        .scrollDismissesKeyboard(.interactively)
#endif
    }
}

#Preview {
    ScanView().environmentObject(AppState())
}
