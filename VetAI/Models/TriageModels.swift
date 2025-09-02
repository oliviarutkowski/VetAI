import Foundation

struct Differential: Codable, Identifiable, Hashable {
    /// Locally generated identifier for displaying lists.
    let id = UUID()
    var condition: String
    var confidencePct: Int

    enum CodingKeys: String, CodingKey {
        case condition
        case confidencePct
    }
}

enum Urgency: String, Codable {
    case low
    case medium
    case high
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = Urgency(rawValue: raw) ?? .unknown
    }
}

struct TriageResult: Codable, Hashable {
    var urgency: Urgency
    var redFlags: [String]?
    var differentials: [Differential]?
    var homeCare: [String]?
    var questions: [String]?
    var disclaimer: String?
}
