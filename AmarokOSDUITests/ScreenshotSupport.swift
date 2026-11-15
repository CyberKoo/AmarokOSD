import AppKit
import XCTest

@MainActor
extension XCTestCase {
    func saveScreenshot(of app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.windows.firstMatch.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func visibleSearchField(in app: XCUIApplication) -> XCUIElement {
        let searchField = app.textFields["feature-search"]
        if searchField.waitForExistence(timeout: 1) {
            return searchField
        }

        let searchButton = app.buttons["feature-search-button"]
        XCTAssertTrue(searchButton.waitForExistence(timeout: 3))
        searchButton.click()
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        return searchField
    }

    func enterText(_ text: String, in element: XCUIElement, using app: XCUIApplication) {
        element.click()
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)

        let chineseEditMenu = app.menuBars.firstMatch.menuBarItems["编辑"]
        if chineseEditMenu.exists {
            chineseEditMenu.click()
            app.menuItems["粘贴"].click()
        } else {
            app.menuBars.firstMatch.menuBarItems["Edit"].click()
            app.menuItems["Paste"].click()
        }
    }

    func resizeWindow(of app: XCUIApplication, to size: CGSize) {
        let window = app.windows.firstMatch
        let frame = window.frame
        let bottomRight = window.coordinate(withNormalizedOffset: CGVector(dx: 0.995, dy: 0.995))
        let destination = bottomRight.withOffset(CGVector(
            dx: size.width - frame.width,
            dy: size.height - frame.height
        ))
        bottomRight.click(forDuration: 0.2, thenDragTo: destination)
    }
}
