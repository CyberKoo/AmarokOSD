import Foundation

struct AgonFeatureRepository {
    func loadFeatures() throws -> [AgonFeature] {
        try AgonClient.featureDefinitions()
    }
}
