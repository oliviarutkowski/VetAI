import Foundation

enum EnvironmentConfig {
#if DEBUG
    static let baseURL = URL(string: "http://127.0.0.1:3000")!
    static let apiToken = ""
#else
    static let baseURL = URL(string: "https://api.yourdomain.com")!
    static let apiToken = ""
#endif
}
