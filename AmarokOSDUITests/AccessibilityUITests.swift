import XCTest

@MainActor
final class AccessibilityUITests: AmarokOSDStateUITestCase {
    func testReduceTransparencyKeepsSelectedRowsVisible() {
        launchApp(scenario: "-SimulatedReduceTransparency")

        let brightnessRow = app.buttons["feature-row-brightness"]
        XCTAssertTrue(brightnessRow.waitForExistence(timeout: 5))
        XCTAssertEqual(brightnessRow.value as? String, "当前值 25")
        saveScreenshot(of: app, named: "stage4-reduced-transparency")
    }

    func testLongFeatureValueIsExposedToAccessibility() {
        launchApp()

        let adaptiveSyncRow = app.buttons["feature-row-adaptive-sync"]
        XCTAssertTrue(adaptiveSyncRow.waitForExistence(timeout: 5))
        XCTAssertEqual(adaptiveSyncRow.value as? String, "当前值 关闭")
        saveScreenshot(of: app, named: "stage4-accessibility-values")
    }

    func testLightAppearance() {
        launchApp(scenario: "-SimulatedLightAppearance")
        saveScreenshot(of: app, named: "stage4-light-appearance")
    }

    func testDarkAppearance() {
        launchApp(scenario: "-SimulatedDarkAppearance")
        XCTAssertTrue(app.buttons["display-info"].exists)
        saveScreenshot(of: app, named: "stage4-dark-appearance")
    }

    func testAboutWindow() {
        launchApp()
        app.menuBars.firstMatch.menuBarItems["AmarokOSD"].click()
        app.menuItems["关于 AmarokOSD"].click()

        XCTAssertTrue(app.links["agon-ctl"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["提供 DDC/CI 通信支持"].exists)
        saveScreenshot(of: app, named: "stage4-about")
        app.buttons["关闭"].click()
    }
}
