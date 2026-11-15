#if DEBUG
import XCTest
@testable import AmarokOSD

final class SimulatedAgonControllerTests: XCTestCase {
    func testRefreshReturnsSimulatedDisplay() async throws {
        let controller = SimulatedAgonController(features: SimulatedValueFactory.makeFeatures())
        let displays = try await controller.refresh()

        XCTAssertEqual(displays.count, 1)
        XCTAssertEqual(displays.first?.id, TestFixtures.displayID)
        XCTAssertEqual(displays.first?.name, "Simulated Display")
    }

    func testNumericReadAndWriteRoundTrip() async throws {
        let controller = SimulatedAgonController(features: SimulatedValueFactory.makeFeatures())
        let initial = try await controller.read(displayID: TestFixtures.displayID, feature: "brightness")
        XCTAssertEqual(initial.current, 25)
        XCTAssertEqual(initial.maximum, 100)

        let written = try await controller.set(
            displayID: TestFixtures.displayID,
            feature: "brightness",
            value: 40
        )
        XCTAssertEqual(written.current, 40)

        let readback = try await controller.read(displayID: TestFixtures.displayID, feature: "brightness")
        XCTAssertEqual(readback.current, 40)
    }

    func testNamedReadAndWriteRoundTrip() async throws {
        let controller = SimulatedAgonController(features: SimulatedValueFactory.makeFeatures())
        let written = try await controller.set(
            displayID: TestFixtures.displayID,
            feature: "game-mode",
            value: 2
        )
        XCTAssertEqual(written.current, 2)
        XCTAssertEqual(written.namedValues.map(\.value), [0, 1, 2, 3])

        let readback = try await controller.read(displayID: TestFixtures.displayID, feature: "game-mode")
        XCTAssertEqual(readback.current, 2)
    }

    func testOutOfRangeWriteIsRejected() async {
        let controller = SimulatedAgonController(features: SimulatedValueFactory.makeFeatures())

        do {
            _ = try await controller.set(
                displayID: TestFixtures.displayID,
                feature: "brightness",
                value: 101
            )
            XCTFail("Expected out-of-range write to fail")
        } catch let error as AgonError {
            XCTAssertEqual(error.kind, .valueAboveMaximum)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testProbeReturnsSupportedFeatureAndValue() async throws {
        let controller = SimulatedAgonController(features: SimulatedValueFactory.makeFeatures())
        let probe = try await controller.probe(displayID: TestFixtures.displayID, feature: "gamma")

        XCTAssertTrue(probe.isSupported)
        XCTAssertEqual(probe.value?.current, 2)
        XCTAssertEqual(probe.value?.capabilities, [0, 1, 2, 3, 4])
    }

    func testUnknownDisplayIsRejected() async {
        let controller = SimulatedAgonController(features: SimulatedValueFactory.makeFeatures())

        do {
            _ = try await controller.read(displayID: "missing", feature: "brightness")
            XCTFail("Expected unknown display to fail")
        } catch let error as AgonError {
            XCTAssertEqual(error.kind, .displayNotFound)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testUnknownFeatureIsRejected() async {
        let controller = SimulatedAgonController(features: SimulatedValueFactory.makeFeatures())

        do {
            _ = try await controller.read(displayID: TestFixtures.displayID, feature: "missing")
            XCTFail("Expected unknown feature to fail")
        } catch let error as AgonError {
            XCTAssertEqual(error.kind, .unsupportedFeature)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
#endif
