import Swift

public struct SwiftAttribute: Codable, Equatable {
    public let serialize: String
    public let isMutating: Bool
    public let isAccessLevel: Bool

    public let isAvailability: Bool
    public let isUnavailable: Bool
    public let isDeprecated: Bool
    public let isRenamed: Bool
    public let isObsoleted: Bool
    public let isDiscardable: Bool
    public let isPublic: Bool
    public let isFinal: Bool
    public let isAlwaysEmitIntoClient: Bool
    public let isObjC: Bool

    public let availableWatchVersion: String?
    public let availableMacVersion: String?
    public let availableTvVersion: String?
    public let availableIVersion: String?

    public init(serialize: String,
                isMutating: Bool,
                isAccessLevel: Bool,
                isAvailability: Bool,
                isUnavailable: Bool,
                isDeprecated: Bool,
                isRenamed: Bool,
                isObsoleted: Bool,
                isDiscardable: Bool,
                isPublic: Bool,
                isFinal: Bool,
                isAlwaysEmitIntoClient: Bool,
                isObjC: Bool,
                availableWatchVersion: String?,
                availableMacVersion: String?,
                availableTvVersion: String?,
                availableIVersion: String?) {
        self.serialize = serialize
        self.isMutating = isMutating
        self.isAccessLevel = isAccessLevel
        self.isAvailability = isAvailability
        self.isUnavailable = isUnavailable
        self.isDeprecated = isDeprecated
        self.isRenamed = isRenamed
        self.isObsoleted = isObsoleted
        self.isDiscardable = isDiscardable
        self.isPublic = isPublic
        self.isFinal = isFinal
        self.isAlwaysEmitIntoClient = isAlwaysEmitIntoClient
        self.isObjC = isObjC
        self.availableWatchVersion = availableWatchVersion
        self.availableMacVersion = availableMacVersion
        self.availableTvVersion = availableTvVersion
        self.availableIVersion = availableIVersion
    }

    public func serializeAvailablePlatforms() -> String {
        var platforms = [String]()
        if let watchVersion = availableWatchVersion {
            platforms.append("watchOS " + watchVersion)
        }
        if let macVersion = availableMacVersion {
            platforms.append("macOS " + macVersion)
        }
        if let tvVersion = availableTvVersion {
            platforms.append("tvOS " + tvVersion)
        }
        if let iVersion = availableIVersion {
            platforms.append("iOS " + iVersion)
        }
        guard !platforms.isEmpty else { return "" }
        platforms.append("*")
        return "@available(\(platforms.joined(separator: ", ")))"
    }
}
