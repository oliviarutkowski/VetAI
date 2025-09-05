import Foundation

struct VetAIAPI {
    struct TriageResult: Codable, Equatable {
        let recommendation: String
        let reasoning: String
    }

    let session: URLSession
    let baseURL: URL
    let token: String

    init(session: URLSession = .shared, baseURL: URL = URL(string: "http://localhost:3000")!, token: String = "") {
        self.session = session
        self.baseURL = baseURL
        self.token = token
    }

    func triage(casePayload: [String: Any]) async throws -> TriageResult {
        var request = URLRequest(url: baseURL.appendingPathComponent("triage"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !token.isEmpty {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONSerialization.data(withJSONObject: casePayload)

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(TriageResult.self, from: data)
    }
}
