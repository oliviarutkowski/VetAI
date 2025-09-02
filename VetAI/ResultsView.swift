import SwiftUI

struct ResultsView: View {
    let result: TriageResult

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.md) {
                urgencySection
                if !result.redFlags.isEmpty {
                    SectionHeader("Red Flags")
                    ForEach(result.redFlags, id: \.self) { flag in
                        Text(flag)
                    }
                }
                SectionHeader("Differentials")
                ForEach(result.differentials, id: \.condition) { diff in
                    HStack {
                        Text(diff.condition)
                        Spacer()
                        Text("\(diff.confidencePct)%")
                    }
                }
                if !result.homeCareTips.isEmpty {
                    SectionHeader("Home Care Tips")
                    ForEach(result.homeCareTips, id: \.self) { tip in
                        Text(tip)
                    }
                }
                if !result.questionsForVet.isEmpty {
                    SectionHeader("Questions for Your Vet")
                    ForEach(result.questionsForVet, id: \.self) { q in
                        Text(q)
                    }
                }
                Text("This information is not a substitute for professional veterinary care.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, Spacing.l)
            }
            .padding(Spacing.l)
        }
        .accessibilityIdentifier("ResultsView")
        .navigationTitle("Results")
    }

    private var urgencySection: some View {
        HStack {
            Text(result.urgency)
                .padding(4)
                .background(Palette.cyan)
                .clipShape(Capsule())
            Spacer()
        }
    }
}

#Preview {
    let sample = TriageResult(
        urgency: "NON_URGENT",
        redFlags: [],
        differentials: [Differential(condition: "Cold", confidencePct: 30)],
        homeCareTips: ["Rest"],
        questionsForVet: ["Is medication needed?"]
    )
    return ResultsView(result: sample)
}
