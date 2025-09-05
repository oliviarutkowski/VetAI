import XCTest
@testable import VetAI

final class VetAIAPITests: XCTestCase {
    func testTriageDecodesERNow() async throws {
        let json = """{\n  \"recommendation\": \"ER_NOW\",\n  \"reasoning\": \"Chocolate is toxic\"\n}""".data(using: .utf8)!
        let url = URL(string: "http://localhost/triage")!
        let session = URLSessionMock { _ in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (json, response)
        }
        let api = VetAIAPI(session: session, baseURL: URL(string: "http://localhost")!, token: "test")
        let result = try await api.triage(casePayload: ["symptom": "ate chocolate"])
        XCTAssertEqual(result.recommendation, "ER_NOW")
    }
}

final class URLSessionMock: URLSession {
    typealias Handler = (URLRequest) throws -> (Data, URLResponse)
    let handler: Handler
    init(handler: @escaping Handler) { self.handler = handler }
    override func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try handler(request)
    }
}
