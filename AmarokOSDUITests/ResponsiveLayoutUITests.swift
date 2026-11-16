import XCTest

@MainActor
final class ResponsiveLayoutUITests: AmarokOSDStateUITestCase {
    func testNarrowWindowStacksFeatureListAboveDetail() {
        launchApp()
        resizeWindow(of: app, to: CGSize(width: 800, height: 700))
        settleLayout()

        XCTAssertTrue(app.descendants(matching: .any)["feature-master-list"].firstMatch.exists)
        XCTAssertTrue(app.descendants(matching: .any)["feature-detail-surface"].firstMatch.exists)
        saveScreenshot(of: app, named: "stage3-stacked-layout")
    }

    func testMediumWindowUsesNarrowerSideBySideList() {
        launchApp()
        resizeWindow(of: app, to: CGSize(width: 960, height: 700))
        settleLayout()

        XCTAssertTrue(app.descendants(matching: .any)["feature-master-list"].firstMatch.exists)
        XCTAssertTrue(app.descendants(matching: .any)["feature-detail-surface"].firstMatch.exists)
        saveScreenshot(of: app, named: "stage3-side-by-side-layout")
    }

    func testSearchIsAccessibleAtCurrentWindowSize() {
        launchApp()
        saveScreenshot(of: app, named: "stage3-measured-header")
        XCTAssertTrue(visibleSearchField(in: app).exists)
    }

    func testOverflowKeepsVisibleCategoriesAndMoreMenu() {
        launchApp()
        resizeWindow(of: app, to: CGSize(width: 800, height: 700))
        settleLayout()

        let moreButton = app.descendants(matching: .any)["更多分类"].firstMatch
        XCTAssertTrue(moreButton.waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["category-picture"].exists || app.buttons["category-gaming"].exists)
        XCTAssertTrue(app.buttons["feature-search-button"].exists)
        saveScreenshot(of: app, named: "stage3-overflow-menu")

        moreButton.click()
        let panelCareItem = app.menuItems["面板维护"]
        XCTAssertTrue(panelCareItem.waitForExistence(timeout: 3))
        panelCareItem.click()
        XCTAssertTrue(app.staticTexts["面板维护"].waitForExistence(timeout: 3))
        saveScreenshot(of: app, named: "stage3-overflow-selection")
    }

    private func settleLayout() {
        Thread.sleep(forTimeInterval: 0.5)
    }
}
