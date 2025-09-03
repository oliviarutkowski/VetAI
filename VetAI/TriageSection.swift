import SwiftUI

struct TriageSection: View {
    @State private var symptomText: String = ""
    @State private var isSubmitting = false
    @State private var result: TriageResult? = nil
    @State private var showToast = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TextEditor(text: $symptomText)
                    .accessibilityIdentifier("symptomField")
                    .frame(height: 150)
                    .border(Color.gray)
                Button(action: submit) {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Text("Submit Symptoms")
                    }
                }
                .disabled(isSubmitting)
                .frame(maxWidth: .infinity)
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top, 16)
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            if showToast {
                Text("Something went wrong")
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .transition(.move(edge: .bottom))
                    .padding()
            }
        }
        .navigationDestination(item: $result) { result in
            ResultsView(result: result)
        }
    }

    private func submit() {
        isSubmitting = true
        let payload = CasePayload(
            pet: PetProfile(name: "", species: "dog", age: 0),
            symptoms: [Symptom(description: symptomText, durationDays: nil)],
            exposures: nil
        )
        Task {
            do {
                let triage = try await LLMClient.shared.triage(payload)
                result = triage
            } catch {
                withAnimation { showToast = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation { showToast = false }
                }
            }
            isSubmitting = false
        }
    }
}

struct ResultsView: View {
    let result: TriageResult
    @State private var showShare = false

    var body: some View {
        List {
            Section("Urgency") { Text(result.urgency.rawValue.capitalized) }
            if let red = result.redFlags {
                Section("Red Flags") {
                    ForEach(red, id: \.self) { Text($0) }
                }
            }
            if let diffs = result.differentials {
                Section("Differentials") {
                    ForEach(diffs) { diff in
                        HStack { Text(diff.condition); Spacer(); Text("\(diff.confidencePct)%") }
                    }
                }
            }
            if let home = result.homeCare {
                Section("Home Care") {
                    ForEach(home, id: \.self) { Text($0) }
                }
            }
            if let questions = result.questions {
                Section("Questions") {
                    ForEach(questions, id: \.self) { q in
                        Text(q)
                            .onTapGesture {
#if os(iOS)
                                UIPasteboard.general.string = q
#endif
                            }
                    }
                }
            }
            if let disclaimer = result.disclaimer {
                Section("Disclaimer") { Text(disclaimer) }
            }
        }
        .navigationTitle("Results")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Share") { showShare = true }
            }
        }
        .sheet(isPresented: $showShare) {
            let renderer = ImageRenderer(content: self)
            if let img = renderer.uiImage {
                ShareLink(item: TransferableImage(image: img),
                          preview: SharePreview("Triage"))
            }
        }
    }
}
