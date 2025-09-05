import Foundation

struct VetAIAPI {
    func triage(_ payload: CasePayload) async throws -> TriageResult {
        var request = URLRequest(url: EnvironmentConfig.baseURL.appendingPathComponent("triage"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !EnvironmentConfig.apiToken.isEmpty {
            request.addValue("Bearer \(EnvironmentConfig.apiToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(TriageResult.self, from: data)
    }
}
