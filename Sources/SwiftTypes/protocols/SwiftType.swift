import Swift

public protocol SwiftType: SwiftConvertible, MaybePublic, MaybeMutating, MaybeUnavailable, MaybeDeprecated, MaybeObsoleted, MaybeRenamed, Accessible {
    var globalName: String { get }
    var properties: [SwiftProperty] { get }
    var methods: [SwiftMethod] { get }
    // TODO: add subscripts
    var isMutating: Bool { get }
    var isProtocol: Bool { get }
}

extension SwiftType {
    public var isMutating: Bool {
        return methods.contains { $0.isMutating } || properties.contains { $0.isMutating } // TODO: account subscripts
    }

    public var isProtocol: Bool {
        return false
    }
}

extension SwiftType where Self == SwiftProtocol {
    public var isProtocol: Bool {
        return true
    }
}
