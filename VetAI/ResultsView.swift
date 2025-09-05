import SwiftUI

struct ResultsView: View {
    @Binding var record: DiagnosisRecord
    @State private var showShare = false

    var body: some View {
        Form {
            Section {
                triageBadge
                Text(record.diagnosis)
                    .font(Typography.title)
                ProgressView("Confidence", value: record.confidence, total: 1)
                Text(record.rationale)
            }

            if let diffs = record.differentials, !diffs.isEmpty {
                Section("Differentials") {
                    ForEach(diffs, id: \.self) { diff in
                        Text(diff)
                    }
                }
            }

            Section("Notes") {
                TextEditor(text: Binding(
                    get: { record.notes ?? "" },
                    set: { record.notes = $0 }
                ))
                .frame(minHeight: 100)
            }
        }
        .navigationTitle("Results")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showShare = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showShare) {
            ShareLink(item: summaryText)
        }
    }

    private var triageBadge: some View {
        let color: Color
        switch record.triageLevel.lowercased() {
        case "high": color = .red
        case "medium": color = .yellow
        case "low": color = .green
        default: color = .gray
        }
        return Text(record.triageLevel.capitalized)
            .padding(8)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
    }

    private var summaryText: String {
        var parts = [
            "Diagnosis: \(record.diagnosis)",
            "Triage: \(record.triageLevel)",
            "Confidence: \(Int(record.confidence * 100))%",
            "Rationale: \(record.rationale)"
        ]
        if let diffs = record.differentials, !diffs.isEmpty {
            parts.append("Differentials: \(diffs.joined(separator: ", "))")
        }
        return parts.joined(separator: "\n")
    }
}
