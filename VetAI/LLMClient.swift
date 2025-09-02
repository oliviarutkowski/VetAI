import Foundation

struct LLMClient {
    enum LLMError: Error { case invalidResponse }
    private let session: URLSession

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        session = URLSession(configuration: config)
    }

    func send(system: String, user: String) async throws -> Data {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(Config.apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "response_format": ["type": "json_object"],
            "messages": [
                ["role": "system", "content": system],
                ["role": "user", "content": user]
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        for attempt in 0..<2 {
            let start = Date()
            do {
                let (data, response) = try await session.data(for: request)
                let elapsed = Date().timeIntervalSince(start)
                VetLog.d("LLM round-trip \(elapsed)s")
                guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                    VetLog.e("Non-200 status: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                    if attempt == 0 { continue } else { throw LLMError.invalidResponse }
                }
                if let content = try? decodeContent(from: data) {
                    return Data(content.utf8)
                } else {
                    VetLog.e("Decode failure")
                    if attempt == 0 { continue } else { throw LLMError.invalidResponse }
                }
            } catch {
                VetLog.e("Request error: \(error.localizedDescription)")
                if attempt == 0 { continue } else { throw error }
            }
        }
        throw LLMError.invalidResponse
    }

    private func decodeContent(from data: Data) throws -> String {
        struct Response: Decodable {
            struct Choice: Decodable {
                struct Message: Decodable { let content: String }
                let message: Message
            }
            let choices: [Choice]
        }
        let decoded = try JSONDecoder().decode(Response.self, from: data)
        return decoded.choices.first?.message.content ?? ""
    }
}
