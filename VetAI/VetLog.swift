import Foundation

enum VetLog {
    static func d(_ message: String) {
        print("[VetAI] \(redact(message))")
    }

    static func e(_ message: String) {
        print("[VetAI][ERROR] \(redact(message))")
    }

    private static func redact(_ message: String) -> String {
        let redacted = message.replacingOccurrences(of: Config.apiKey, with: "[REDACTED]")
        return redacted
    }
}
