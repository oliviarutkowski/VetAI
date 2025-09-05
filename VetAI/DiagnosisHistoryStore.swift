import Foundation

enum DiagnosisHistoryStore {
    private static var fileURL: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent("diagnosisHistory.json")
    }

    static func load() -> [DiagnosisRecord] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        return (try? JSONDecoder().decode([DiagnosisRecord].self, from: data)) ?? []
    }

    static func save(_ records: [DiagnosisRecord]) {
        guard let data = try? JSONEncoder().encode(records) else { return }
        try? data.write(to: fileURL)
    }
}
