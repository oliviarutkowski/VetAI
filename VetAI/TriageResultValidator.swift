import Foundation

enum TriageResultValidator {
    enum ValidationError: Error {
        case invalidUrgency
        case tooManyDifferentials
        case invalidConfidence
    }

    static func validate(_ result: TriageResult) throws {
        let valid = ["ER_NOW", "URGENT_24H", "NON_URGENT"]
        guard valid.contains(result.urgency) else {
            throw ValidationError.invalidUrgency
        }
        guard result.differentials.count <= 5 else {
            throw ValidationError.tooManyDifferentials
        }
        for diff in result.differentials {
            guard (0...100).contains(diff.confidencePct) else {
                throw ValidationError.invalidConfidence
            }
        }
    }
}
