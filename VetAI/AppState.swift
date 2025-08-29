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

struct DiagnosisRecord: Identifiable, Equatable {
    let id = UUID()
    var species: String
    var diagnosis: String
    var confidenceScore: Int
    var date: Date = Date()
    var petID: UUID? = nil
}

