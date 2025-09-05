import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        List {
            ForEach($appState.diagnosisHistory) { $record in
                NavigationLink(destination: ResultsView(record: $record)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(record.date, style: .date)
                                .font(Typography.caption)
                                .foregroundColor(.secondary)
                            if let petID = record.petID,
                               let pet = appState.pets.first(where: { $0.id == petID }) {
                                Text(pet.name).font(.headline)
                            } else {
                                Text(record.species.capitalized).font(.headline)
                            }
                            Text(record.diagnosis)
                                .font(Typography.body)
                        }
                        Spacer()
                        triageBadge(for: record.triageLevel)
                    }
                }
            }
        }
        .navigationTitle("History")
    }

    private func triageBadge(for level: String) -> some View {
        let color: Color
        switch level.lowercased() {
        case "high": color = .red
        case "medium": color = .yellow
        case "low": color = .green
        default: color = .gray
        }
        return Text(level.capitalized)
            .padding(4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}
