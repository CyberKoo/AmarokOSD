import XCTest
@testable import AmarokOSD

final class FeatureWorkspaceHeaderLayoutTests: XCTestCase {
    private let widths: [FeatureCategory: Double] = [
        .picture: 48,
        .gaming: 48,
        .color: 48,
        .inputAndAudio: 96,
        .lighting: 48,
        .panelCare: 72,
        .other: 48
    ]

    private var categories: [FeatureCategory] {
        FeatureCategory.allCases
    }

    private func resolve(_ availableWidth: Double) -> FeatureWorkspaceHeaderLayout {
        FeatureWorkspaceHeaderLayout.resolve(
            availableWidth: availableWidth,
            categories: categories,
            widths: widths
        )
    }

    /// Width the header asks for with the given number of visible categories.
    private func headerWidth(visibleCount: Int, showsSearchField: Bool) -> Double {
        let tabs = categories.prefix(visibleCount).reduce(0.0) { $0 + (widths[$1] ?? 88) }
        let spacing = FeatureWorkspaceHeaderLayout.tabSpacing * Double(max(0, visibleCount - 1))
        let strip = tabs + spacing + FeatureWorkspaceHeaderLayout.tabStripPadding
        let hasOverflow = visibleCount < categories.count && visibleCount > 0
        let search = showsSearchField
            ? FeatureWorkspaceHeaderLayout.searchFieldWidth
            : FeatureWorkspaceHeaderLayout.searchButtonWidth
        return strip
            + (hasOverflow ? FeatureWorkspaceHeaderLayout.overflowMenuWidth : 0)
            + FeatureWorkspaceHeaderLayout.contentSpacing
            + search
    }

    func testShowsEveryCategoryAndSearchFieldWhenThereIsRoom() {
        let layout = resolve(1_000)
        XCTAssertEqual(layout.visibleCount, categories.count)
        XCTAssertTrue(layout.showsSearchField)
        XCTAssertFalse(layout.isCompact)
    }

    func testCollapsesSearchFieldBeforeCategories() {
        let fullWidth = headerWidth(visibleCount: categories.count, showsSearchField: true)
        let withoutField = headerWidth(visibleCount: categories.count, showsSearchField: false)

        let layout = resolve(fullWidth - 1)
        XCTAssertEqual(layout.visibleCount, categories.count)
        XCTAssertFalse(layout.showsSearchField)
        XCTAssertEqual(
            headerWidth(visibleCount: layout.visibleCount, showsSearchField: layout.showsSearchField),
            withoutField
        )
    }

    func testMovesOverflowingCategoriesIntoMoreMenu() {
        let layout = resolve(450)

        XCTAssertEqual(layout.visibleCount, 5)
        XCTAssertFalse(layout.showsSearchField)
        XCTAssertFalse(layout.isCompact)
        XCTAssertLessThanOrEqual(
            headerWidth(visibleCount: layout.visibleCount, showsSearchField: layout.showsSearchField),
            450
        )
    }

    func testResolvedHeaderAlwaysFitsAvailableWidth() {
        let compactWidth = FeatureWorkspaceHeaderLayout.overflowMenuButtonWidth
            + FeatureWorkspaceHeaderLayout.compactSpacing
            + FeatureWorkspaceHeaderLayout.searchButtonWidth

        for width in stride(from: 120.0, through: 1_200.0, by: 10.0) {
            let layout = resolve(width)
            if layout.isCompact {
                XCTAssertLessThanOrEqual(compactWidth, width, "Compact header overflows at \(width)")
                continue
            }
            XCTAssertLessThanOrEqual(
                headerWidth(visibleCount: layout.visibleCount, showsSearchField: layout.showsSearchField),
                width,
                "Header overflows at \(width)"
            )
        }
    }

    func testUsesActualCategoryWidths() {
        var wide = widths
        wide[.inputAndAudio] = 200

        let narrowLayout = FeatureWorkspaceHeaderLayout.resolve(
            availableWidth: 560,
            categories: categories,
            widths: widths
        )
        let wideLayout = FeatureWorkspaceHeaderLayout.resolve(
            availableWidth: 560,
            categories: categories,
            widths: wide
        )

        XCTAssertGreaterThan(narrowLayout.visibleCount, wideLayout.visibleCount)
    }

    func testShowsCompactLayoutOnlyWhenASingleCategoryCannotFit() {
        let oneTabWidth = headerWidth(visibleCount: 1, showsSearchField: false)

        XCTAssertFalse(resolve(oneTabWidth).isCompact)
        XCTAssertTrue(resolve(oneTabWidth - 1).isCompact)
        XCTAssertEqual(resolve(oneTabWidth - 1).visibleCount, 0)
    }

    func testLayoutRestoresImmediatelyWhenWidthReturns() {
        let wide = resolve(450)
        _ = resolve(360)
        let restored = resolve(450)

        XCTAssertEqual(wide, restored)
        XCTAssertEqual(restored.visibleCount, 5)
    }

    func testKeepsCategoriesVisibleBeforeWidthIsKnown() {
        let layout = resolve(0)

        XCTAssertEqual(layout.visibleCount, categories.count)
        XCTAssertFalse(layout.isCompact)
    }

    func testExactFitIsAccepted() {
        let fieldWidth = headerWidth(visibleCount: categories.count, showsSearchField: true)
        XCTAssertTrue(resolve(fieldWidth).showsSearchField)
        XCTAssertFalse(resolve(fieldWidth - 1).showsSearchField)

        let allTabsWidth = headerWidth(visibleCount: categories.count, showsSearchField: false)
        XCTAssertEqual(resolve(allTabsWidth).visibleCount, categories.count)
        XCTAssertLessThan(resolve(allTabsWidth - 1).visibleCount, categories.count)
    }

    func testSegmentInsetsPreserveOriginalStripWidthAndTextPositions() {
        var segmentWidth = 0.0

        for (index, category) in categories.enumerated() {
            let isFirst = index == 0
            let isLast = index == categories.count - 1
            let leading = FeatureWorkspaceHeaderLayout.categoryLeadingInset(isFirst: isFirst)
            let trailing = FeatureWorkspaceHeaderLayout.categoryTrailingInset(isLast: isLast)
            let textWidth = (widths[category] ?? 88) - FeatureWorkspaceHeaderLayout.categoryHorizontalInset * 2
            let originalTextOrigin = categories.prefix(index).reduce(0.0) { $0 + (widths[$1] ?? 88) }
                + FeatureWorkspaceHeaderLayout.tabSpacing * Double(index)
                + FeatureWorkspaceHeaderLayout.tabStripPadding / 2
                + FeatureWorkspaceHeaderLayout.categoryHorizontalInset

            XCTAssertEqual(segmentWidth + leading, originalTextOrigin)
            segmentWidth += leading + textWidth + trailing
        }

        XCTAssertEqual(
            segmentWidth,
            headerWidth(visibleCount: categories.count, showsSearchField: false)
                - FeatureWorkspaceHeaderLayout.contentSpacing
                - FeatureWorkspaceHeaderLayout.searchButtonWidth
        )
    }
}
