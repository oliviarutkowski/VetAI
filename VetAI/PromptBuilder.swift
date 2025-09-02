import Foundation

enum PromptBuilder {
    static let system = "You are a veterinary triage assistant that replies with JSON."

    static func user(from payload: CasePayload) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(payload),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return json
    }
}
