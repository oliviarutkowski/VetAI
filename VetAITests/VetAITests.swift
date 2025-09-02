//
//  VetAITests.swift
//  VetAITests
//
//  Created by Olivia on 7/23/25.
//

import Testing
@testable import VetAI

struct VetAITests {

    @Test func decodeTriageResult() throws {
        let json = """
        {
            "urgency":"NON_URGENT",
            "redFlags":[],
            "differentials":[{"condition":"Cold","confidencePct":50}],
            "homeCareTips":[],
            "questionsForVet":[]
        }
        """.data(using: .utf8)!
        let result = try JSONDecoder().decode(TriageResult.self, from: json)
        #expect(result.urgency == "NON_URGENT")
    }

    @Test func validatorRejectsInvalidUrgency() throws {
        let bad = TriageResult(
            urgency: "BAD",
            redFlags: [],
            differentials: [],
            homeCareTips: [],
            questionsForVet: []
        )
        #expect(throws: TriageResultValidator.ValidationError.self) {
            try TriageResultValidator.validate(bad)
        }
    }

    @Test func promptIncludesFields() {
        let payload = CasePayload(
            petProfile: PetProfile(species: "dog", name: nil),
            symptoms: [Symptom(text: "cough")],
            exposuresRisks: ExposuresRisks(medications: nil, toxins: nil),
            wbc: nil,
            rbc: nil,
            glucose: nil
        )
        let json = PromptBuilder.user(from: payload)
        #expect(json.contains("\"petProfile\""))
        #expect(json.contains("\"symptoms\""))
        #expect(json.contains("\"exposuresRisks\""))
    }
}
