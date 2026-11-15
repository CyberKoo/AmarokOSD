import XCTest
@testable import AmarokOSD

@MainActor
final class FeatureCatalogStoreTests: XCTestCase {
    private var brightness: AgonFeature {
        TestFixtures.feature()
    }

    private var gamma: AgonFeature {
        TestFixtures.feature(name: "gamma", address: "0x32")
    }

    private var inputSource: AgonFeature {
        TestFixtures.feature(name: "input-source", address: "0x40")
    }

    private var pixelOrbiting: AgonFeature {
        TestFixtures.feature(name: "pixel-orbiting", address: "0x60")
    }

    func testInitialSelectionAndBlankSearch() {
        let store = FeatureCatalogStore(features: [brightness, gamma])

        XCTAssertEqual(store.selectedName, "brightness")
        XCTAssertEqual(store.selectedFeature, brightness)
        XCTAssertFalse(store.hasSearchQuery)

        store.searchText = "  \n"
        XCTAssertFalse(store.hasSearchQuery)
        XCTAssertEqual(store.filteredFeatures, [brightness, gamma])

        store.selectedName = "missing"
        XCTAssertNil(store.selectedFeature)
    }

    func testSearchMatchesTitleNameAndAddress() {
        let store = FeatureCatalogStore(features: [brightness, gamma, inputSource])

        store.searchText = "亮度"
        XCTAssertEqual(store.filteredFeatures, [brightness])

        store.searchText = "GAMMA"
        XCTAssertEqual(store.filteredFeatures, [gamma])

        store.searchText = " 0x40 "
        XCTAssertEqual(store.filteredFeatures, [inputSource])
        XCTAssertTrue(store.hasSearchQuery)

        store.searchText = "not-present"
        XCTAssertTrue(store.filteredFeatures.isEmpty)
    }

    func testCategoryFilteringAlsoAppliesSearch() {
        let store = FeatureCatalogStore(features: [brightness, gamma, inputSource])
        store.searchText = "0x"

        XCTAssertEqual(store.filteredFeatures(in: .picture), [brightness])
        XCTAssertEqual(store.filteredFeatures(in: .gaming), [gamma])
        XCTAssertEqual(store.filteredFeatures(in: .inputAndAudio), [inputSource])
        XCTAssertTrue(store.filteredFeatures(in: .color).isEmpty)
    }

    func testPopulatedCategoriesFollowCategoryOrder() {
        let store = FeatureCatalogStore(features: [pixelOrbiting, inputSource, brightness])
        XCTAssertEqual(store.populatedCategories, [.picture, .inputAndAudio, .panelCare])
    }

    func testVisibleCategoriesRequireAdjustableReadyFeatures() {
        let features = [brightness, inputSource, pixelOrbiting]
        let catalog = FeatureCatalogStore(features: features)
        let states = FeatureStateStore()
        states.beginProbe(features: features)
        states.recordProbe(.ready(TestFixtures.value()), for: brightness, completed: 1)
        states.recordProbe(.unsupported, for: inputSource, completed: 2)
        states.recordProbe(.ready(TestFixtures.value(maximum: 0)), for: pixelOrbiting, completed: 3)

        XCTAssertEqual(catalog.visibleCategories(using: states), [.picture])
    }

    func testCategorySelectionClearsSearchAndChoosesCategoryFeature() {
        let store = FeatureCatalogStore(features: [brightness, gamma])
        store.selectedName = gamma.name
        store.searchText = "gamma"

        store.selectCategory(.picture)

        XCTAssertEqual(store.selectedCategory, .picture)
        XCTAssertEqual(store.selectedName, brightness.name)
        XCTAssertEqual(store.searchText, "")
    }

    func testClearingSearchRestoresSelectedFeatureCategory() {
        let store = FeatureCatalogStore(features: [brightness, gamma])
        store.selectedName = gamma.name
        store.searchText = "gamma"

        store.updateSearchText("")

        XCTAssertEqual(store.selectedCategory, .gaming)
        XCTAssertEqual(store.selectedName, gamma.name)
        XCTAssertEqual(store.searchText, "")
    }
}
