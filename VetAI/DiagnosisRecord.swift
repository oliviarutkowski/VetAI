import Foundation

struct DiagnosisRecord: Identifiable {
    let id = UUID()
    let species: String
    let symptoms: String
    let wbc: String
    let rbc: String
    let glucose: String
    let diagnosisResult: String
    let confidence: String
}

