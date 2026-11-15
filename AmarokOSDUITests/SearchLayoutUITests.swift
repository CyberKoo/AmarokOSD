import XCTest

@MainActor
final class SearchLayoutUITests: AmarokOSDStateUITestCase {
    func testCompactSearchRemainsAccessibleWhileResultsAreActive() {
        launchApp()
        resizeWindow(of: app, to: CGSize(width: 800, height: 692))

        let searchButton = app.buttons["feature-search-button"]
        XCTAssertTrue(searchButton.waitForExistence(timeout: 5))
        searchButton.click()

        let searchField = app.textFields["feature-search"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        searchField.click()
        enterText("gamma", in: searchField, using: app)
        XCTAssertTrue(app.staticTexts["搜索结果"].waitForExistence(timeout: 3))
        saveScreenshot(of: app, named: "stage1-compact-search-expanded")

        let closeButton = app.buttons["feature-search-close"]
        XCTAssertTrue(closeButton.waitForExistence(timeout: 3))
        closeButton.click()
        XCTAssertTrue(searchButton.waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["搜索结果"].exists)
        saveScreenshot(of: app, named: "stage1-compact-search-active")

        searchButton.click()
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        XCTAssertEqual(searchField.value as? String, "gamma")
    }
}
