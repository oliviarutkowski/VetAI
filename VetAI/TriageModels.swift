import Foundation

struct PetProfile: Codable {
    var species: String
    var name: String?
}

struct Symptom: Codable {
    var text: String
}

struct ExposuresRisks: Codable {
    var medications: [String]?
    var toxins: [String]?
}

struct CasePayload: Codable {
    var petProfile: PetProfile
    var symptoms: [Symptom]
    var exposuresRisks: ExposuresRisks
    var wbc: Double?
    var rbc: Double?
    var glucose: Double?
}

struct Differential: Codable {
    var condition: String
    var confidencePct: Int
}

struct TriageResult: Codable {
    var urgency: String
    var redFlags: [String]
    var differentials: [Differential]
    var homeCareTips: [String]
    var questionsForVet: [String]
}
