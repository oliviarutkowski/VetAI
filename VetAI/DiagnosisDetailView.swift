import SwiftUI

struct DiagnosisDetailView: View {
    let record: DiagnosisRecord
    @EnvironmentObject var appState: AppState

    var body: some View {
        Form {
            Section(header: Text("Diagnosis")) {
                if let petID = record.petID,
                   let pet = appState.pets.first(where: { $0.id == petID }) {
                    HStack { Text("Pet"); Spacer(); Text(pet.name) }
                }
                HStack { Text("Species"); Spacer(); Text(record.species) }
                HStack { Text("Diagnosis"); Spacer(); Text(record.diagnosis) }
                HStack { Text("Confidence"); Spacer(); Text("\(record.confidenceScore)%") }
                HStack { Text("Date"); Spacer(); Text(record.date, style: .date) }
            }
        }
        .navigationTitle("Diagnosis Detail")
    }
}

#Preview {
    DiagnosisDetailView(
        record: DiagnosisRecord(species: "dog", diagnosis: "Possible anemia", confidenceScore: 70)
    ).environmentObject(AppState())
}
