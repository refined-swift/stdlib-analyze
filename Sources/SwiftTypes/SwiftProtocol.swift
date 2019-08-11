import Swift

public struct SwiftProtocol: Codable, Equatable {
    public var serialize: String {
        fatalError() // FIXME: implement associated types first
    }
    
    public let globalName: String
    public let inheritedProtocols: [String]
    public let properties: [SwiftProperty]
    public let methods: [SwiftMethod]
    public let subscriptCount: Int
    public let isUnavailable: Bool
    public let isDeprecated: Bool
    public let isRenamed: Bool
    public let isObsoleted: Bool
    public let accessLevel: String
    
    public var isPublic: Bool {
        return accessLevel == "public"
    }
    
    public init(globalName: String,
                inheritedProtocols: [String],
                properties: [SwiftProperty],
                methods: [SwiftMethod],
                subscriptCount: Int,
                isUnavailable: Bool,
                isDeprecated: Bool,
                isRenamed: Bool,
                isObsoleted: Bool,
                accessLevel: String) {
        self.globalName = globalName
        self.inheritedProtocols = inheritedProtocols
        self.properties = properties
        self.methods = methods
        self.subscriptCount = subscriptCount
        self.isUnavailable = isUnavailable
        self.isDeprecated = isDeprecated
        self.isRenamed = isRenamed
        self.isObsoleted = isObsoleted
        self.accessLevel = accessLevel
    }
}
