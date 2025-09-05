import Foundation

struct CasePayload: Codable {
    struct PetProfile: Codable {
        var name: String
        var species: String
        var age: Int
    }

    struct Symptom: Codable, Identifiable {
        var id = UUID()
        var description: String
        var durationDays: Int?
    }

    struct ExposuresRisks: Codable {
        var toxins: [String]?
        var travel: [String]?
        var others: [String]?
    }

    var pet: PetProfile
    var symptoms: [Symptom]
    var exposures: ExposuresRisks?
    var wbc: Double?
    var rbc: Double?
    var glucose: Double?
}

struct TriageResult: Codable, Identifiable {
    var caseID: String
    var triageLevel: String
    var diagnosis: String
    var confidence: Double
    var rationale: String
    var differentials: [String]?
    var createdAt: Date?

    var id: String { caseID }
}
