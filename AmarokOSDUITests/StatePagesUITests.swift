import XCTest

@MainActor
final class StatePagesUITests: AmarokOSDStateUITestCase {
    func testInitialProbeUsesSingleProgressCard() {
        launchApp(scenario: "-SimulatedSlowProbing", waitsForMainPage: false)

        XCTAssertTrue(app.staticTexts["正在探测功能"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["正在与显示器通信…"].exists)
        saveScreenshot(of: app, named: "stage2-initial-probe")
    }

    func testNoSupportedFeaturesUsesWorkspaceStateCard() {
        launchApp(scenario: "-SimulatedNoSupportedFeatures", waitsForMainPage: false)

        XCTAssertTrue(app.staticTexts["没有支持的功能"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.descendants(matching: .any)["no-supported-features-state"].firstMatch.exists)
        XCTAssertFalse(app.buttons["feature-search-button"].exists)
        XCTAssertFalse(app.textFields["feature-search"].exists)
        saveScreenshot(of: app, named: "stage2-no-supported-features")
    }

    func testNoDisplaysState() {
        launchApp(scenario: "-SimulatedNoDisplays", waitsForMainPage: false)

        XCTAssertTrue(app.staticTexts["未发现可控制的显示器"].waitForExistence(timeout: 10))
        saveScreenshot(of: app, named: "stage2-no-displays")
    }

    func testReadFailureState() {
        launchApp(scenario: "-SimulatedProbeFailure", waitsForMainPage: false)

        XCTAssertTrue(app.staticTexts["读取失败"].waitForExistence(timeout: 10))
        saveScreenshot(of: app, named: "stage2-read-failure")
    }

    func testSearchEmptyStateUsesWorkspaceStateCard() {
        launchApp()
        let searchField = visibleSearchField(in: app)
        enterText("no-such-feature", in: searchField, using: app)

        XCTAssertTrue(app.descendants(matching: .any)["search-empty-state"].firstMatch.waitForExistence(timeout: 5))
        saveScreenshot(of: app, named: "stage2-search-empty")
    }

    func testRefreshOverlayDoesNotMoveConnectionCard() {
        launchApp(scenario: "-SimulatedSlowProbing")
        let infoButton = app.buttons["display-info"]
        let initialFrame = infoButton.frame

        app.buttons["display-refresh"].click()
        let status = app.descendants(matching: .any)["display-discovery-status"].firstMatch
        XCTAssertTrue(status.waitForExistence(timeout: 5))
        XCTAssertEqual(infoButton.frame, initialFrame)
        saveScreenshot(of: app, named: "stage2-refresh-overlay")
    }
}
