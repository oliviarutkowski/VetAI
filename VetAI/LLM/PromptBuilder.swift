import Foundation

enum PromptBuilder {
    static let system = "You are a helpful veterinary triage assistant."

    static func user(from payload: CasePayload) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(payload) else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
}
