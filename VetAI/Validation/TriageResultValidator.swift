import Foundation

enum TriageValidationError: Error {
    case invalidUrgency
    case tooManyDifferentials
    case invalidConfidence
    case missingField
}

struct TriageResultValidator {
    func validate(_ result: TriageResult) throws {
        guard result.urgency != .unknown else { throw TriageValidationError.invalidUrgency }
        guard let diffs = result.differentials,
              result.redFlags != nil,
              result.homeCare != nil,
              result.questions != nil else {
            throw TriageValidationError.missingField
        }
        guard diffs.count <= 5 else { throw TriageValidationError.tooManyDifferentials }
        for diff in diffs {
            guard (0...100).contains(diff.confidencePct) else { throw TriageValidationError.invalidConfidence }
        }
    }
}
