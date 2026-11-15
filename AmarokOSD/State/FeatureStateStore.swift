import Foundation

@MainActor
final class FeatureStateStore: ObservableObject {
    @Published private(set) var states: [String: AgonFeatureState] = [:]
    @Published private(set) var readingFeature: String?
    @Published private(set) var writingFeature: String?
    @Published private(set) var isProbing = false
    @Published private(set) var completedProbes = 0
    private var probeCache: [String: [String: AgonFeatureState]] = [:]

    func beginRead(for feature: AgonFeature) -> AgonValue? {
        readingFeature = feature.name
        guard case .ready(let value)? = states[feature.name] else {
            states[feature.name] = .loading
            return nil
        }
        return value
    }

    func finishRead(_ value: AgonValue, for feature: AgonFeature, displayID: String) {
        guard readingFeature == feature.name else { return }
        states[feature.name] = .ready(value)
        readingFeature = nil
        updateCachedProbe(for: displayID, feature: feature.name)
    }

    func failRead(
        for feature: AgonFeature,
        displayID: String,
        previousValue: AgonValue?,
        failure: AgonFeatureState
    ) {
        guard readingFeature == feature.name else { return }
        states[feature.name] = previousValue.map { .ready($0) } ?? failure
        readingFeature = nil
        updateCachedProbe(for: displayID, feature: feature.name)
    }

    func beginProbe(features: [AgonFeature]) {
        isProbing = true
        completedProbes = 0
        states = Dictionary(uniqueKeysWithValues: features.map { ($0.name, AgonFeatureState.loading) })
    }

    func recordProbe(_ state: AgonFeatureState, for feature: AgonFeature, completed: Int) {
        guard isProbing else { return }
        states[feature.name] = state
        completedProbes = completed
    }

    func finishProbe(for displayID: String) {
        guard isProbing else { return }
        probeCache[displayID] = states
        isProbing = false
    }

    func beginWrite(for feature: AgonFeature) -> Bool {
        guard writingFeature == nil else { return false }
        writingFeature = feature.name
        return true
    }

    func finishWrite(_ value: AgonValue, for feature: AgonFeature, displayID: String) {
        guard writingFeature == feature.name else { return }
        states[feature.name] = .ready(value)
        writingFeature = nil
        updateCachedProbe(for: displayID, feature: feature.name)
    }

    func failWrite(for feature: AgonFeature) {
        guard writingFeature == feature.name else { return }
        writingFeature = nil
    }

    func restoreCachedProbe(for displayID: String) -> Bool {
        guard let cached = probeCache[displayID],
              cached.values.allSatisfy({ $0 != .loading && $0 != .idle }) else { return false }
        states = cached
        return true
    }

    func reset() {
        states = [:]
    }

    func cancelRead() {
        if let readingFeature, states[readingFeature] == .loading {
            states[readingFeature] = .idle
        }
        readingFeature = nil
    }

    func cancelProbe() {
        isProbing = false
        completedProbes = 0
        for (name, state) in states where state == .loading {
            states[name] = .idle
        }
    }

    func cancelWrite() {
        writingFeature = nil
    }

    func cancelOperations() {
        cancelRead()
        cancelProbe()
        cancelWrite()
    }

    func state(for feature: AgonFeature) -> AgonFeatureState {
        states[feature.name] ?? .idle
    }

    func visibleFeatures(from features: [AgonFeature]) -> [AgonFeature] {
        features.filter {
            if case .failed = state(for: $0) { return true }
            guard case .ready(let value) = state(for: $0) else { return false }
            return $0.hasAdjustableValues(for: value)
        }
    }

    private func updateCachedProbe(for displayID: String, feature: String) {
        guard probeCache[displayID] != nil else { return }
        probeCache[displayID]?[feature] = states[feature] ?? .idle
    }
}
