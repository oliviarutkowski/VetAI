import Foundation

struct PetProfile: Codable {
    var name: String
    var species: String
    var age: Int
}

struct Symptom: Codable, Identifiable {
    let id = UUID()
    var description: String
    var durationDays: Int?
}

struct ExposuresRisks: Codable {
    var toxins: [String]?
    var travel: [String]?
    var others: [String]?
}

struct CasePayload: Codable {
    var pet: PetProfile
    var symptoms: [Symptom]
    var exposures: ExposuresRisks?
}
