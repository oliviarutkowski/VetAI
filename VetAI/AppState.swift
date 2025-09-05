import SwiftUI

final class AppState: ObservableObject {
    @Published var ownerName: String = ""
    @Published var ownerEmail: String = ""
    @Published var pets: [Pet] = []
    @Published var diagnosisHistory: [DiagnosisRecord] = [] {
        didSet { DiagnosisHistoryStore.save(diagnosisHistory) }
    }

    init() {
        diagnosisHistory = DiagnosisHistoryStore.load()
    }
}

struct Pet: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var species: String
    var age: Int
}

struct DiagnosisRecord: Identifiable, Equatable, Codable {
    let id: UUID
    var species: String
    var diagnosis: String
    var triageLevel: String
    var rationale: String
    var confidence: Double
    var differentials: [String]?
    var notes: String?
    var date: Date
    var petID: UUID?

    init(id: UUID = UUID(), species: String, diagnosis: String, triageLevel: String, rationale: String, confidence: Double, differentials: [String]? = nil, notes: String? = nil, date: Date = Date(), petID: UUID? = nil) {
        self.id = id
        self.species = species
        self.diagnosis = diagnosis
        self.triageLevel = triageLevel
        self.rationale = rationale
        self.confidence = confidence
        self.differentials = differentials
        self.notes = notes
        self.date = date
        self.petID = petID
    }
}
