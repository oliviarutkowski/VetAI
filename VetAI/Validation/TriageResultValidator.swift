import Foundation

enum TriageValidationError: Error {
    case invalidTriageLevel
    case tooManyDifferentials
    case invalidConfidence
}

struct TriageResultValidator {
    func validate(_ result: TriageResult) throws {
        // triage level should not be empty or the placeholder "unknown"
        guard !result.triageLevel.isEmpty,
              result.triageLevel.lowercased() != "unknown" else {
            throw TriageValidationError.invalidTriageLevel
        }

        // confidence should be provided as a fraction between 0 and 1
        guard (0.0...1.0).contains(result.confidence) else {
            throw TriageValidationError.invalidConfidence
        }

        // differentials are optional but limited in number when present
        if let diffs = result.differentials {
            guard diffs.count <= 5 else {
                throw TriageValidationError.tooManyDifferentials
            }
        }
    }
}
