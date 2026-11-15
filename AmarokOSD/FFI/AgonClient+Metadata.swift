import Foundation

extension AgonClient {
    static func featureDefinitions() throws -> [AgonFeature] {
        try (0..<agon_feature_count()).map { index in
            var info = agon_feature_info_t()
            let status = agon_feature_get(index, &info)
            guard status == UInt32(AGON_OK) else {
                throw AgonError(status: status, message: "无法读取功能元数据")
            }
            return AgonFeature(
                name: AgonFFI.string(from: info.name),
                address: AgonFFI.string(from: info.address),
                namedValues: try namedValues(forFeatureNamed: AgonFFI.string(from: info.name), maximum: 0),
                supportPath: try supportPath(forFeatureAt: index)
            )
        }
    }

    static func value(
        forFeatureNamed feature: String,
        from rawValue: agon_value_t,
        displayID: String,
        session: AgonSessionHandle
    ) throws -> AgonValue {
        AgonValue(
            current: rawValue.current,
            maximum: rawValue.maximum,
            namedValues: try namedValues(forFeatureNamed: feature, maximum: rawValue.maximum),
            capabilities: try capabilities(
                forFeatureNamed: feature,
                displayID: displayID,
                session: session
            )
        )
    }

    static func namedValues(forFeatureNamed feature: String, maximum: UInt16) throws -> [AgonNamedValue] {
        let featureIndex = try featureIndex(for: feature)
        var list: OpaquePointer?
        var error: OpaquePointer?
        let status = agon_feature_named_values(featureIndex, maximum, &list, &error)
        defer { agon_named_value_list_destroy(list) }
        try AgonFFI.check(status, error: error)
        guard let list else { return [] }

        return try (0..<agon_named_value_list_count(list)).map { valueIndex in
            var value = agon_named_value_t()
            let status = agon_named_value_list_get(list, valueIndex, &value)
            guard status == UInt32(AGON_OK) else {
                throw AgonError(status: status, message: "无法读取动态命名值元数据")
            }
            return AgonNamedValue(name: AgonFFI.string(from: value.name), value: value.value)
        }
    }

    private static func capabilities(
        forFeatureNamed feature: String,
        displayID: String,
        session: AgonSessionHandle
    ) throws -> [UInt8] {
        let featureIndex = try featureIndex(for: feature)
        guard try supportPath(forFeatureAt: featureIndex) == .capabilityList else { return [] }

        var list: OpaquePointer?
        var error: OpaquePointer?
        let status = displayID.withCString { displayID in
            feature.withCString { feature in
                agon_feature_capabilities(session.pointer, displayID, feature, &list, &error)
            }
        }
        defer { agon_capability_list_destroy(list) }
        try AgonFFI.check(status, error: error)
        guard let list else { return [] }

        return try (0..<agon_capability_list_count(list)).map { index in
            var value: UInt8 = 0
            let status = agon_capability_list_get(list, index, &value)
            guard status == UInt32(AGON_OK) else {
                throw AgonError(status: status, message: "无法读取设备能力列表")
            }
            return value
        }
    }

    private static func supportPath(forFeatureAt index: Int) throws -> AgonSupportPath {
        var rawPath = UInt32(AGON_SUPPORT_PATH_NOT_APPLICABLE)
        let status = agon_feature_support_path(index, &rawPath)
        guard status == UInt32(AGON_OK) else {
            throw AgonError(status: status, message: "无法读取支持值策略")
        }
        guard let path = AgonSupportPath(rawValue: rawPath) else {
            throw AgonError(status: UInt32(AGON_INTERNAL_ERROR), message: "未知支持值策略：\(rawPath)")
        }
        return path
    }

    private static func featureIndex(for featureName: String) throws -> Int {
        for index in 0..<agon_feature_count() {
            var info = agon_feature_info_t()
            let status = agon_feature_get(index, &info)
            guard status == UInt32(AGON_OK) else {
                throw AgonError(status: status, message: "无法读取功能元数据")
            }
            if AgonFFI.string(from: info.name) == featureName {
                return index
            }
        }
        throw AgonError(status: UInt32(AGON_INVALID_ARGUMENT), message: "未知功能：\(featureName)")
    }
}
