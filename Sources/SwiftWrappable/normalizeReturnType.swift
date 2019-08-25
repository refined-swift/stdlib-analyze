import Swift
import Idioms
import SwiftTypes
import SwiftTypesMappers

public func isOptionalSyntacticSugarType(_ typeName: String) -> Bool {
    return typeName.hasSuffix("?")
}

public func isDictionarySyntacticSugarType(_ typeName: String) -> Bool {
    return typeName.hasPrefix("[") &&
        typeName.hasSuffix("]") &&
        typeName.contains(":")
}

public func isArraySyntacticSugarType(_ typeName: String) -> Bool {
    return typeName.hasPrefix("[") &&
        typeName.hasSuffix("]") &&
        !typeName.contains(":")
}

public func normalizeReturnType(_ original: String, associatedTypes: [String], associatedTypesParent: String = "WrappedValue") -> String {
    // This method will fail to normalize types with parametrized generic parameters (e.g. A<B<C>>)
    let candidates = original
        .components(separatedBy: CharacterSet(charactersIn: "<,>"))
        .compactMap { $0.isEmpty ? nil : $0 }
        .reduce(into: [String]()) { result, step in
            if isOptionalSyntacticSugarType(step) {
                result.append("Optional")
                result.append(step.removingSuffix("?"))
            } else if isDictionarySyntacticSugarType(step) {
                result.append("Dictionary")
                let types = step
                    .removingPrefix("[")
                    .removingSuffix("]")
                    .components(separatedBy: ":")
                for type in types {
                    result.append(type.trimmingCharacters(in: .whitespaces))
                }
            } else if isArraySyntacticSugarType(step) {
                result.append("Array")
                result.append(step.removingPrefix("[").removingSuffix("]"))
            } else {
                result.append(step)
            }
        }.map { wellKnownTypealiases[$0] ?? $0 }
    var returnType = ""
    for candidate in candidates {
        if let genericPartameterClosingRange = original.range(of: ">"),
            let candidateRange = original.range(of: candidate),
            genericPartameterClosingRange.lowerBound < candidateRange.lowerBound {
            returnType += ">"
        } else {
            returnType += returnType.isEmpty ? "" : returnType.contains("<") ? ", " : "<"
        }
        if candidate != "Self" && associatedTypes.contains(candidate) {
            returnType += "\(associatedTypesParent).\(candidate)"
        } else {
            returnType += candidate
        }
    }
    if returnType.contains("<") && !returnType.contains(">") {
        returnType += ">"
    }
    return returnType
}
