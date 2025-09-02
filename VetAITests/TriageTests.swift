import XCTest
@testable import VetAI

final class TriageTests: XCTestCase {
    func testDecodeSample() throws {
        let json = """
        {
            "urgency":"low",
            "redFlags":["none"],
            "differentials":[{"condition":"cold","confidencePct":50}],
            "homeCare":["rest"],
            "questions":["how long?"],
            "disclaimer":"not for emergencies"
        }
        """
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder().decode(TriageResult.self, from: data)
        XCTAssertEqual(result.urgency, .low)
        XCTAssertEqual(result.differentials?.count, 1)
    }

    func testValidatorRejectsBadUrgency() {
        let bad = TriageResult(urgency: .unknown, redFlags: [], differentials: [], homeCare: [], questions: [], disclaimer: "")
        let validator = TriageResultValidator()
        XCTAssertThrowsError(try validator.validate(bad))
    }

    func testPromptBuilderHasFields() {
        let payload = CasePayload(
            pet: PetProfile(name: "Rex", species: "dog", age: 5),
            symptoms: [Symptom(description: "cough", durationDays: nil)],
            exposures: nil
        )
        let userPrompt = PromptBuilder.user(from: payload)
        XCTAssertTrue(userPrompt.contains("pet"))
        XCTAssertTrue(userPrompt.contains("symptoms"))
    }
}
