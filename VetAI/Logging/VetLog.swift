import Foundation

enum VetLog {
    private static func redact(_ text: String) -> String {
        var redacted = text
        let emailPattern = "[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}"
        if let regex = try? NSRegularExpression(pattern: emailPattern, options: [.caseInsensitive]) {
            let range = NSRange(location: 0, length: redacted.count)
            redacted = regex.stringByReplacingMatches(in: redacted, options: [], range: range, withTemplate: "<redacted>")
        }
        if let apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String, !apiKey.isEmpty {
            redacted = redacted.replacingOccurrences(of: apiKey, with: "<redacted>")
        }
        return redacted
    }

    static func d(_ message: String) {
        print("DEBUG: \(redact(message))")
    }

    static func e(_ message: String) {
        print("ERROR: \(redact(message))")
    }
}
