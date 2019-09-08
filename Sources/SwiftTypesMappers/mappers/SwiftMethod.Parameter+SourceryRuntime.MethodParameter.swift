import Foundation
import SourceryRuntime
import SwiftTypes

extension SwiftMethod.Parameter {
    /// Maps given SourceryRuntime parameter (and the method it belongs to) into a parameter object.
    public init(_ parameter: SourceryRuntime.MethodParameter, method: SourceryRuntime.Method) {
        let simplifiedType = parameter
            .typeName
            .name
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: "->", with: "")
        
        let isInOut = parameter.typeAttributes["inout"] != nil
        let isEscaping = parameter.typeAttributes["escaping"] != nil
        let isOwned = parameter.typeAttributes["__owned"] != nil
        let isSelf = simplifiedType == "Self" || simplifiedType.hasPrefix("Self ") || simplifiedType.hasSuffix(" Self")
        
        self = SwiftMethod.Parameter(label: parameter.argumentLabel ?? "_",
                                     internalName: parameter.name,
                                     position: method.parameters.firstIndex(of: parameter) ?? -1,
                                     type: parameter.typeName.name,
                                     isInOut: isInOut,
                                     isEscaping: isEscaping,
                                     isOwned: isOwned,
                                     isSelf: isSelf)
        assert(self.position != -1, "method \(method.name) does not contain parameter \(parameter.name)")
    }
}
