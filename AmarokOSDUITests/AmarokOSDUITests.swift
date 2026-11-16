import XCTest

@MainActor
final class AmarokOSDUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-SimulatedUI"]
        app.launch()

        XCTAssertTrue(app.windows.firstMatch.waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["feature-read"].waitForExistence(timeout: 10))
    }

    override func tearDown() async throws {
        app.terminate()
        app = nil
    }

    func testMainPageShowsDisplayAndBrightnessEditor() {
        XCTAssertTrue(app.staticTexts["显示器"].exists)
        XCTAssertTrue(app.buttons["display-refresh"].exists)
        XCTAssertTrue(app.buttons["display-info"].exists)
        XCTAssertTrue(app.staticTexts["已连接"].exists)
        XCTAssertTrue(app.buttons["feature-row-brightness"].exists)
        XCTAssertTrue(app.sliders["feature-value-slider"].exists)
        XCTAssertTrue(app.buttons["feature-increment"].exists)
        XCTAssertFalse(app.buttons["feature-apply"].isEnabled)
        saveScreenshot(of: app, named: "stage2-main-ambient")
    }

    func testDisplayInformationPopover() {
        app.buttons["display-info"].click()

        XCTAssertTrue(app.staticTexts["Simulated Display"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["厂商"].exists)
        XCTAssertTrue(app.staticTexts["1234"].exists)
        XCTAssertTrue(app.staticTexts["型号"].exists)
        XCTAssertTrue(app.staticTexts["5678"].exists)
        XCTAssertTrue(app.staticTexts["序列号"].exists)
        XCTAssertTrue(app.staticTexts["42"].exists)
        XCTAssertTrue(app.staticTexts["IOService:/simulation/display-1"].exists)
    }

    func testDisplayRefreshKeepsMainPageUsable() {
        app.buttons["display-refresh"].click()

        XCTAssertTrue(app.buttons["display-info"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["feature-row-brightness"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["feature-read"].waitForExistence(timeout: 10))
    }

    func testCategoryAndFeatureNavigation() {
        selectGamingCategory()

        let gammaRow = app.buttons["feature-row-gamma"]
        XCTAssertTrue(gammaRow.waitForExistence(timeout: 5))
        gammaRow.click()

        XCTAssertTrue(app.staticTexts["Gamma"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["gamma"].exists)
        XCTAssertTrue(app.buttons["feature-read"].exists)
    }

    func testSearchFiltersFeaturesAndOpensResult() {
        let searchField = visibleSearchField(in: app)
        searchField.click()
        enterText("gamma", in: searchField, using: app)

        XCTAssertTrue(app.staticTexts["搜索结果"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["feature-row-gamma"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.buttons["feature-row-brightness"].exists)

        app.buttons["feature-row-gamma"].click()
        XCTAssertTrue(app.staticTexts["Gamma"].waitForExistence(timeout: 3))
        saveScreenshot(of: app, named: "stage1-search-results")

        app.buttons["清除搜索"].click()
        XCTAssertTrue(app.staticTexts["游戏"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Gamma"].exists)
        saveScreenshot(of: app, named: "stage1-search-selection-restored")
    }

    func testCategorySelectionExitsSearch() {
        let searchField = visibleSearchField(in: app)
        searchField.click()
        enterText("gamma", in: searchField, using: app)
        XCTAssertTrue(app.staticTexts["搜索结果"].waitForExistence(timeout: 3))

        let closeButton = app.buttons["feature-search-close"]
        if closeButton.exists {
            closeButton.click()
        }
        selectGamingCategory()

        XCTAssertTrue(app.staticTexts["游戏"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["feature-row-gamma"].exists)

        let clearedSearchField = visibleSearchField(in: app)
        XCTAssertEqual(clearedSearchField.value as? String, "")
        if closeButton.exists {
            closeButton.click()
        }
        saveScreenshot(of: app, named: "stage1-category-exits-search")
    }

    func testNumericEditCanBeAppliedAndReadBack() {
        let applyButton = app.buttons["feature-apply"]
        XCTAssertFalse(applyButton.isEnabled)

        app.buttons["feature-increment"].click()
        XCTAssertTrue(app.staticTexts["26"].waitForExistence(timeout: 3))
        XCTAssertTrue(applyButton.isEnabled)

        applyButton.click()
        let disabledExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "enabled == false"),
            object: applyButton
        )
        XCTAssertEqual(XCTWaiter.wait(for: [disabledExpectation], timeout: 5), .completed)
        XCTAssertTrue(app.staticTexts["已读取"].exists)

        app.buttons["feature-read"].click()
        XCTAssertTrue(app.staticTexts["26"].waitForExistence(timeout: 3))
    }

    private func selectGamingCategory() {
        let gamingTab = app.buttons["category-gaming"]
        if gamingTab.waitForExistence(timeout: 1), gamingTab.isHittable {
            gamingTab.click()
            return
        }

        let categoryMenu = app.descendants(matching: .any)["更多分类"].firstMatch
        XCTAssertTrue(categoryMenu.waitForExistence(timeout: 3))
        categoryMenu.click()

        let gamingItem = app.menuItems["游戏"]
        XCTAssertTrue(gamingItem.waitForExistence(timeout: 3))
        gamingItem.click()
    }
}
