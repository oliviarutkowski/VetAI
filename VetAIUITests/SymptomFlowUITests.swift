import XCTest

final class SymptomFlowUITests: XCTestCase {
    func testSymptomSubmissionFlow() {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["AI Diagnosis"].tap()
        let field = app.textViews.matching(identifier: "symptomField").firstMatch
        field.tap()
        field.typeText("cough")
        app.buttons["Submit Symptoms"].tap()
        XCTAssertTrue(app.navigationBars["Results"].waitForExistence(timeout: 2))
    }
}
