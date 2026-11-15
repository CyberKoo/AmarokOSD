import XCTest
@testable import AmarokOSD

@MainActor
final class FeatureStateStoreTests: XCTestCase {
    private let feature = TestFixtures.feature()

    func testReadFailureRestoresPreviousValue() {
        let store = FeatureStateStore()
        let original = TestFixtures.value(current: 20)
        store.beginProbe(features: [feature])
        store.recordProbe(.ready(original), for: feature, completed: 1)
        store.finishProbe(for: TestFixtures.displayID)

        XCTAssertEqual(store.beginRead(for: feature), original)
        XCTAssertEqual(store.readingFeature, feature.name)
        store.failRead(
            for: feature,
            displayID: TestFixtures.displayID,
            previousValue: original,
            failure: .failed("failed")
        )

        XCTAssertEqual(store.state(for: feature), .ready(original))
        XCTAssertNil(store.readingFeature)
    }

    func testReadFailureWithoutPreviousValueUsesFailureState() {
        let store = FeatureStateStore()
        XCTAssertNil(store.beginRead(for: feature))
        XCTAssertEqual(store.state(for: feature), .loading)

        store.failRead(
            for: feature,
            displayID: TestFixtures.displayID,
            previousValue: nil,
            failure: .failed("failed")
        )

        XCTAssertEqual(store.state(for: feature), .failed("failed"))
        XCTAssertNil(store.readingFeature)
    }

    func testStaleReadCompletionIsIgnored() {
        let store = FeatureStateStore()
        let otherFeature = TestFixtures.feature(name: "contrast")
        _ = store.beginRead(for: feature)
        store.finishRead(TestFixtures.value(), for: otherFeature, displayID: TestFixtures.displayID)

        XCTAssertEqual(store.state(for: feature), .loading)
        XCTAssertEqual(store.readingFeature, feature.name)

        store.cancelRead()
        XCTAssertEqual(store.state(for: feature), .idle)
        XCTAssertNil(store.readingFeature)
    }

    func testProbeCompletionAndCancellation() {
        let store = FeatureStateStore()
        let otherFeature = TestFixtures.feature(name: "contrast")
        let value = TestFixtures.value()
        store.beginProbe(features: [feature, otherFeature])
        store.recordProbe(.ready(value), for: feature, completed: 1)

        XCTAssertTrue(store.isProbing)
        XCTAssertEqual(store.completedProbes, 1)

        store.cancelProbe()
        XCTAssertFalse(store.isProbing)
        XCTAssertEqual(store.completedProbes, 0)
        XCTAssertEqual(store.state(for: feature), .ready(value))
        XCTAssertEqual(store.state(for: otherFeature), .idle)

        store.recordProbe(.ready(value), for: otherFeature, completed: 2)
        XCTAssertEqual(store.state(for: otherFeature), .idle)
        XCTAssertEqual(store.completedProbes, 0)
    }

    func testCompletedProbeCanBeRestoredFromCache() {
        let store = FeatureStateStore()
        let value = TestFixtures.value()
        store.beginProbe(features: [feature])
        store.recordProbe(.ready(value), for: feature, completed: 1)
        store.finishProbe(for: TestFixtures.displayID)
        store.reset()

        XCTAssertTrue(store.restoreCachedProbe(for: TestFixtures.displayID))
        XCTAssertEqual(store.state(for: feature), .ready(value))
        XCTAssertFalse(store.restoreCachedProbe(for: "another-display"))
    }

    func testIncompleteProbeCacheIsNotRestored() {
        let store = FeatureStateStore()
        store.beginProbe(features: [feature])
        store.finishProbe(for: TestFixtures.displayID)
        store.reset()

        XCTAssertFalse(store.restoreCachedProbe(for: TestFixtures.displayID))
        XCTAssertEqual(store.state(for: feature), .idle)
    }

    func testSuccessfulReadUpdatesProbeCache() {
        let store = FeatureStateStore()
        let original = TestFixtures.value(current: 20)
        let updated = TestFixtures.value(current: 40)
        store.beginProbe(features: [feature])
        store.recordProbe(.ready(original), for: feature, completed: 1)
        store.finishProbe(for: TestFixtures.displayID)

        XCTAssertEqual(store.beginRead(for: feature), original)
        store.finishRead(updated, for: feature, displayID: TestFixtures.displayID)
        store.reset()
        XCTAssertTrue(store.restoreCachedProbe(for: TestFixtures.displayID))
        XCTAssertEqual(store.state(for: feature), .ready(updated))
    }

    func testOnlyOneWriteCanBeginAtATime() {
        let store = FeatureStateStore()
        let otherFeature = TestFixtures.feature(name: "contrast")

        XCTAssertTrue(store.beginWrite(for: feature))
        XCTAssertFalse(store.beginWrite(for: otherFeature))
        store.failWrite(for: otherFeature)
        XCTAssertEqual(store.writingFeature, feature.name)

        let value = TestFixtures.value(current: 40)
        store.finishWrite(value, for: feature, displayID: TestFixtures.displayID)
        XCTAssertNil(store.writingFeature)
        XCTAssertEqual(store.state(for: feature), .ready(value))
        XCTAssertTrue(store.beginWrite(for: otherFeature))

        store.cancelWrite()
        XCTAssertNil(store.writingFeature)
    }

    func testVisibleFeaturesRequireReadyAdjustableValues() {
        let store = FeatureStateStore()
        let fixedFeature = TestFixtures.feature(name: "fixed")
        let namedFeature = TestFixtures.feature(
            name: "game-mode",
            namedValues: [AgonNamedValue(name: "standard", value: 0)]
        )
        let unsupportedFeature = TestFixtures.feature(name: "unsupported")
        let failedFeature = TestFixtures.feature(name: "failed")
        let features = [feature, fixedFeature, namedFeature, unsupportedFeature, failedFeature]
        store.beginProbe(features: features)
        store.recordProbe(.ready(TestFixtures.value()), for: feature, completed: 1)
        store.recordProbe(.ready(TestFixtures.value(maximum: 0)), for: fixedFeature, completed: 2)
        store.recordProbe(.ready(TestFixtures.value()), for: namedFeature, completed: 3)
        store.recordProbe(.unsupported, for: unsupportedFeature, completed: 4)
        store.recordProbe(.failed("failed"), for: failedFeature, completed: 5)

        XCTAssertEqual(store.visibleFeatures(from: features), [feature, namedFeature, failedFeature])
    }

    func testCancelOperationsClearsTransientState() {
        let store = FeatureStateStore()
        store.beginProbe(features: [feature])
        _ = store.beginRead(for: feature)
        XCTAssertTrue(store.beginWrite(for: feature))

        store.cancelOperations()

        XCTAssertNil(store.readingFeature)
        XCTAssertNil(store.writingFeature)
        XCTAssertFalse(store.isProbing)
        XCTAssertEqual(store.completedProbes, 0)
        XCTAssertEqual(store.state(for: feature), .idle)
    }
}
