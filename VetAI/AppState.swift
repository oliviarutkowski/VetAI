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
    var result: String
    var confidence: Double
    var date: Date = Date()
    var petID: UUID? = nil
}

