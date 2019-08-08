import Foundation
import SourceryRuntime
import SwiftTypes

extension SwiftMethod.Parameter {
    public init(_ parameter: SourceryRuntime.MethodParameter) {
        let simplifiedType = parameter.typeName.name.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: "->", with: "")

        let isInOut = parameter.typeAttributes["inout"] != nil
        let isEscaping = parameter.typeAttributes["escaping"] != nil
        let isOwned = parameter.typeAttributes["__owned"] != nil
        let isSelf = simplifiedType == "Self" || simplifiedType.hasPrefix("Self ") || simplifiedType.hasSuffix(" Self")

        self = SwiftMethod.Parameter(label: parameter.name,
                                     type: parameter.typeName.name,
                                     isInOut: isInOut,
                                     isEscaping: isEscaping,
                                     isOwned: isOwned,
                                     isSelf: isSelf)
    }
}
