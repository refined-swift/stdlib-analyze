import Foundation
import SourceryRuntime
import SwiftTypes

extension SwiftProperty {
    public init(_ variable: SourceryRuntime.Variable, typeName: String) {
        let attributes: [SourceryRuntime.Attribute] = Array(variable.attributes.values)
        self = SwiftProperty(attributes: attributes.compactMap(SwiftAttribute.init),
                             isMutating: variable.isMutable,
                             isStatic: variable.isStatic,
                             accessLevel: variable.readAccess,
                             definedInType: variable.definedInType?.name ?? typeName,
                             writeAccessLevel: variable.writeAccess,
                             name: variable.name,
                             returnType: variable.typeName.name,
                             isDefinedInProtocol: (variable.definedInType as? SourceryRuntime.SourceryProtocol != nil))
    }
}
