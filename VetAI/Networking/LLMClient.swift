import Foundation

struct ChatMessage: Codable {
    let role: String
    let content: String
}

struct ChatRequest: Codable {
    let model: String
    let messages: [ChatMessage]
}

struct ChatResponse: Codable {
    struct Choice: Codable {
        let message: ChatMessage
    }
    let choices: [Choice]
}

final class LLMClient {
    static let shared = LLMClient()
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        session = URLSession(configuration: config)
    }

    func send(messages: [ChatMessage]) async throws -> ChatResponse {
        let apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String ?? ""
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(ChatRequest(model: "gpt-3.5-turbo", messages: messages))

        var attempt = 0
        let maxAttempts = 2
        while attempt < maxAttempts {
            attempt += 1
            let start = Date()
            do {
                let (data, response) = try await session.data(for: request)
                let duration = Date().timeIntervalSince(start)
                VetLog.d("LLM round trip: \(duration)s")
                guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                do {
                    return try JSONDecoder().decode(ChatResponse.self, from: data)
                } catch {
                    VetLog.e("JSON decode error: \(error)")
                    if attempt >= maxAttempts { throw error }
                }
            } catch {
                VetLog.e("Request error: \(error)")
                if attempt >= maxAttempts { throw error }
            }
        }
        throw URLError(.badServerResponse)
    }

    func triage(_ payload: CasePayload) async throws -> TriageResult {
        let userPrompt = PromptBuilder.user(from: payload)
        let messages = [
            ChatMessage(role: "system", content: PromptBuilder.system),
            ChatMessage(role: "user", content: userPrompt)
        ]
        let response = try await send(messages: messages)
        guard let content = response.choices.first?.message.content.data(using: .utf8) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(TriageResult.self, from: content)
    }
}
