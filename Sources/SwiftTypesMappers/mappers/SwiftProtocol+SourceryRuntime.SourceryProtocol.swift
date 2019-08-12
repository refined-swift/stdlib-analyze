import Foundation
import SourceryRuntime
import SwiftTypes

extension SwiftProtocol {
    public init(_ type: SourceryRuntime.SourceryProtocol) {
        let attributes = type.attributes.compactMap { SwiftAttribute($0.1) }
        assert(Array(type.based.keys) == Array(type.based.values))
        // FIXME: associated values in methods, properties and subscripts will not have type, but should have typeName

        self = SwiftProtocol(globalName: type.name,
                             inheritedProtocols: Array(type.based.keys),
                             properties: type.variables.map { SwiftProperty($0, typeName: type.name) },
                             methods: type.methods.map { SwiftMethod($0, typeName: type.name) },
                             subscriptCount: type.subscripts.count,
                             isUnavailable: attributes.contains { $0.isUnavailable },
                             isDeprecated: attributes.contains { $0.isDeprecated },
                             isRenamed: attributes.contains { $0.isRenamed },
                             isObsoleted: attributes.contains { $0.isObsoleted },
                             accessLevel: type.accessLevel)
    }
}
