import SwiftUI

final class AppState: ObservableObject {
    @Published var ownerName: String = ""
    @Published var ownerEmail: String = ""
    @Published var pets: [Pet] = []
    @Published var diagnosisHistory: [DiagnosisRecord] = []
}

struct Pet: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var species: String
    var age: Int
}

struct DiagnosisRecord: Identifiable {
    let id = UUID()
    var petID: UUID? = nil
    var species: String
    var symptoms: String
    var wbc: String
    var rbc: String
    var glucose: String
    var result: String
    var confidence: String
    var date: Date = Date()
}

