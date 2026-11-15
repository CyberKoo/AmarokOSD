import XCTest

@MainActor
class AmarokOSDStateUITestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() async throws {
        app.terminate()
        app = nil
    }

    func launchApp(scenario: String? = nil, waitsForMainPage: Bool = true) {
        app.launchArguments = ["-SimulatedUI"]
        if let scenario {
            app.launchArguments.append(scenario)
        }
        app.launch()

        XCTAssertTrue(app.windows.firstMatch.waitForExistence(timeout: 10))
        if waitsForMainPage {
            XCTAssertTrue(app.buttons["feature-read"].waitForExistence(timeout: 10))
        }
    }
}
