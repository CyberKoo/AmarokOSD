import XCTest
@testable import AmarokOSD

final class AgonFeatureTests: XCTestCase {
    func testValueDomainDistinguishesNumericAndNamedFeatures() {
        XCTAssertEqual(TestFixtures.feature().valueDomain, .number)
        XCTAssertEqual(
            TestFixtures.feature(namedValues: [AgonNamedValue(name: "off", value: 0)]).valueDomain,
            .named
        )
        XCTAssertEqual(TestFixtures.feature(supportPath: .capabilityList).valueDomain, .named)
        XCTAssertEqual(TestFixtures.feature(supportPath: .maximum).valueDomain, .named)
    }

    func testNumericWriteValidation() {
        let feature = TestFixtures.feature()
        let value = TestFixtures.value(maximum: 100)

        XCTAssertEqual(feature.numericMaximum(for: value), 100)
        XCTAssertTrue(feature.canWrite(0, for: value))
        XCTAssertTrue(feature.canWrite(100, for: value))
        XCTAssertFalse(feature.canWrite(101, for: value))
        XCTAssertTrue(feature.hasAdjustableValues(for: value))

        let fixedValue = TestFixtures.value(maximum: 0)
        XCTAssertFalse(feature.canWrite(0, for: fixedValue))
        XCTAssertFalse(feature.hasAdjustableValues(for: fixedValue))
    }

    func testCapabilityValuesPreserveOrderDeduplicateAndProvideFallbacks() {
        let namedValues = [
            AgonNamedValue(name: "off", value: 0),
            AgonNamedValue(name: "on", value: 1)
        ]
        let feature = TestFixtures.feature(namedValues: namedValues, supportPath: .capabilityList)
        let value = TestFixtures.value(capabilities: [1, 1, 2, 0])
        let expected = [
            namedValues[1],
            AgonNamedValue(name: "2", value: 2),
            namedValues[0]
        ]

        XCTAssertEqual(feature.availableNamedValues(for: value), expected)
        XCTAssertEqual(feature.renderStrategy(for: value), .capabilityList(expected))
    }

    func testMaximumAndStaticNamedValuesUseExpectedSources() {
        let metadata = [
            AgonNamedValue(name: "off", value: 0),
            AgonNamedValue(name: "on", value: 1)
        ]
        let runtimeValues = [AgonNamedValue(name: "custom", value: 2)]
        let value = TestFixtures.value(namedValues: runtimeValues)

        let maximumFeature = TestFixtures.feature(namedValues: metadata, supportPath: .maximum)
        XCTAssertEqual(maximumFeature.availableNamedValues(for: value), runtimeValues)
        XCTAssertEqual(maximumFeature.renderStrategy(for: value), .maximum(runtimeValues))

        let staticFeature = TestFixtures.feature(namedValues: metadata)
        XCTAssertEqual(staticFeature.availableNamedValues(for: value), metadata)
        XCTAssertEqual(staticFeature.renderStrategy(for: value), .staticNamed(metadata))
    }

    func testNamedWriteValidationOnlyAcceptsAvailableValues() {
        let feature = TestFixtures.feature(
            namedValues: [
                AgonNamedValue(name: "off", value: 0),
                AgonNamedValue(name: "on", value: 1)
            ]
        )
        let value = TestFixtures.value(current: 0, maximum: 1)

        XCTAssertTrue(feature.canWrite(1, for: value))
        XCTAssertFalse(feature.canWrite(2, for: value))
        XCTAssertTrue(feature.hasAdjustableValues(for: value))
        XCTAssertNil(feature.numericMaximum(for: value))
    }

    func testNamedFeatureWithoutValuesIsNotAdjustable() {
        let feature = TestFixtures.feature(supportPath: .maximum)
        XCTAssertFalse(feature.hasAdjustableValues(for: TestFixtures.value()))
    }

    func testDisplayTextUsesNamedBooleanAndNumericRepresentations() {
        let namedFeature = TestFixtures.feature(
            namedValues: [AgonNamedValue(name: "off", value: 0)]
        )
        XCTAssertEqual(namedFeature.valueDomain, .named)
        XCTAssertEqual(TestFixtures.value(current: 0).displayText(for: namedFeature), "关闭")

        let booleanFeature = TestFixtures.feature()
        XCTAssertEqual(TestFixtures.value(current: 1, maximum: 1).displayText(for: booleanFeature), "开启")
        XCTAssertEqual(TestFixtures.value(current: 0, maximum: 1).displayText(for: booleanFeature), "关闭")
        XCTAssertEqual(TestFixtures.value(current: 2, maximum: 1).displayText(for: booleanFeature), "2")
        XCTAssertEqual(TestFixtures.value(current: 25).displayText(for: booleanFeature), "25")
    }

    func testDisplayTextPrefersRuntimeNamedMetadata() {
        let feature = TestFixtures.feature(
            namedValues: [AgonNamedValue(name: "on", value: 1)]
        )
        let value = TestFixtures.value(
            current: 1,
            namedValues: [AgonNamedValue(name: "custom", value: 1)]
        )

        XCTAssertEqual(value.displayText(for: feature), "Custom")
    }

    func testWriteConfirmationIsLimitedToRiskyFeatures() {
        XCTAssertTrue(TestFixtures.feature(name: "input-source").requiresWriteConfirmation)
        XCTAssertTrue(TestFixtures.feature(name: "pixel-orbiting").requiresWriteConfirmation)
        XCTAssertTrue(TestFixtures.feature(name: "thermal-protection").requiresWriteConfirmation)
        XCTAssertFalse(TestFixtures.feature(name: "brightness").requiresWriteConfirmation)
    }
}
