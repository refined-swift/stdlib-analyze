import Swift

public struct SwiftFeature: Codable, Equatable {
    public enum FeatureType: String, Codable, Equatable {
        case method
        case property
        case `subscript`
    }
    public let featureType: FeatureType
    public let featureName: String
    public let signature: String
    public let available: String
    public let callName: String
    public let returnType: String
    public let types: [String]
    public let protocols: [String]
    public let matchingProtocols: [String]
    // TODO: add subscripts
}
