import Foundation
import Idioms
import SourceryRuntime
import SwiftTypes
import SwiftTypesMappers

// FIXME: @hectr duplicated code --------------
private func isOptionalSyntacticSugarType(_ typeName: String) -> Bool {
    return typeName.hasSuffix("?")
}

private func isDictionarySyntacticSugarType(_ typeName: String) -> Bool {
    return typeName.hasPrefix("[") &&
        typeName.hasSuffix("]") &&
        typeName.contains(":")
}

private func isArraySyntacticSugarType(_ typeName: String) -> Bool {
    return typeName.hasPrefix("[") &&
        typeName.hasSuffix("]") &&
        !typeName.contains(":")
}

private func normalizeReturnType(_ original: String, associatedTypes: [String], associatedTypesParent: String = "WrappedValue") -> String {
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
        }
        .map { wellKnownTypealiases[$0] ?? $0 }
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
// ----------------------------------------------------------

private func returnTypeForOperatorInProtocol(_ method: SwiftMethod) -> String {
    guard method.definedInType != "Bool" else { return "Bool" }
    return method.returnType == method.definedInType || method.returnType.hasPrefix("\(method.definedInType) ")
        ? "Self"
        : method.returnType
}

private func parameterNameAtPosition(_ position: Int) -> String {
    if position == 0 {
        return "lhs"
    } else {
        assert(position == 1, "operators are expected to have 1 or 2 parameters only")
        return "rhs"
    }
}

private func parameterTypeForMethodAsDeclaredInProtocol(_ param: SwiftMethod.Parameter, method: SwiftMethod) -> String {
    let type = param
        .type
        .removingPrefix("inout ")
    let normalized = normalizeReturnType(type, associatedTypes: [])
    let generics = normalized
        .components(separatedBy: "<")
        .dropFirst()
        .joined(separator: "<")
        .components(separatedBy: ">")
        .dropLast()
        .joined(separator: ">")
    let typeWithoutGenericParameters = normalized
        .replacingOccurrences(of: "<\(generics)>", with: "")
    let definedInTypeWithoutParent = method.definedInType
        .components(separatedBy: ".").last
    return typeWithoutGenericParameters == method.definedInType ||
        typeWithoutGenericParameters == definedInTypeWithoutParent
        ? "Self"
        : type
}

extension SwiftFeature {
    private static func isFeatureCompatibleOperator(_ method: SwiftMethod) -> Bool {
        return method.isPublic &&
            !method.isMutating &&
            method.isOperator &&
            method.returnType != "Void" &&
            !method.definedInType.hasPrefix("_") &&
            !method.definedInType.hasSuffix("_") &&
            method.parameters.map { $0.type }.contains { $0.hasPrefix("_") || $0.hasSuffix("_") }
    }

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    static func parseOperators(in sourceryTypes: SourceryRuntime.Types,
                               minimumCardinality: Int,
                               includeUnavailable: Bool,
                               includeDeprecated: Bool,
                               includeRenamed: Bool,
                               includeObsoleted: Bool) -> [SwiftFeature] {
        let publicProtocols = sourceryTypes.protocols.map { SwiftProtocol($0, knownTypes: sourceryTypes.all.map { $0.name }) }.filter { $0.isPublic }
        let nonProtocolPublicMethods = sourceryTypes
            .all
            .filter { /* !($0 is SourceryProtocol) &&*/ $0.accessLevel == "public" }
            .flatMap { type in
                return type.methods.map { SwiftMethod($0, typeName: type.name) }
            }
            .filter { isFeatureCompatibleOperator($0) &&
                (!$0.isUnavailable || includeUnavailable) &&
                (!$0.isDeprecated || includeDeprecated) &&
                (!$0.isRenamed || includeRenamed) &&
                (!$0.isObsoleted || includeObsoleted)
            }
        
        var allMethods = [String: SwiftMethod]()
        var names = [String: String]()
        
        // swiftlint:disable:next closure_body_length
        let crossReference = Dictionary(grouping: nonProtocolPublicMethods) { (method: SwiftMethod) -> String in
            let parameters = method
                .parameters
                .map { SwiftMethod.Parameter(label: "_",
                                             internalName: parameterNameAtPosition($0.position),
                                             position: $0.position,
                                             type: parameterTypeForMethodAsDeclaredInProtocol($0, method: method),
                                             isInOut: $0.isInOut,
                                             isEscaping: $0.isEscaping,
                                             isOwned: $0.isOwned,
                                             isSelf: $0.isSelf)
                }
            
            let signature = SwiftMethod.serialization(available: method.available,
                                                      attributes: method.attributes,
                                                      skipAttributes: true,
                                                      accessLevel: method.accessLevel,
                                                      isStatic: method.isStatic,
                                                      isInit: method.isInit,
                                                      isFailableInit: method.isFailableInit,
                                                      isOperator: method.isOperator,
                                                      shortName: method.shortName,
                                                      parameters: parameters,
                                                      isThrowing: method.isThrowing,
                                                      isRethrowing: method.isRethrowing,
                                                      returnType: returnTypeForOperatorInProtocol(method),
                                                      isDefinedInProtocol: true)
            var name = method.callName.capitalized
            for parameter in parameters {
                name.append("_")
                if parameter.externalLabel != "_" {
                    name.append(parameter.externalLabel.capitalized)
                } else {
                    name.append(parameter.internalName.capitalized)
                }
            }
            name = name.components(separatedBy: " ").joined(separator: "_").snakeToCamelCased()
            if method.isOperator &&
                (parameters.filter { $0.type == "Self" || $0.type == method.definedInType }).count != parameters.count {
                if (parameters.filter { $0.type == parameters.first?.type }).count == parameters.count {
                    names[signature] = method.featureName(prefix: parameters.first?.type.removingSuffix("?"))
                } else {
                    names[signature] = method.featureName(prefix: parameters.first?.type.removingSuffix("?"),
                                                          suffix: parameters.last?.type.removingSuffix("?"))
                }
            } else {
                names[signature] = method.featureName()
            }
            allMethods[signature] = method.updatingParameters(to: parameters)
            
            return signature
        }
        
        let duplicates: [String] = crossReference
            .filter { $1.count >= minimumCardinality }
            .compactMap { $0.0 }
        
        var features = [SwiftFeature]()
        for signature in duplicates {
            guard let methods = crossReference[signature] else { continue }
            var protocols = [SwiftProtocol]()
            for aProtocol in publicProtocols {
                if (aProtocol.methods.map { $0.serialize }).contains(signature) {
                    protocols.append(aProtocol)
                }
            }
            
            guard let method = allMethods[signature] else { fatalError("allMethods keys should contain: \(signature)") }
            guard let name = names[signature] else { fatalError("names keys should contain: \(signature)") }
            let protocolNames = protocols
                .map { $0.globalName }
                .sorted()
            
            let valueTypes = (sourceryTypes.structs + sourceryTypes.enums)
                .filter { $0.accessLevel == "public" }
            
            var types = methods.map { $0.definedInType }
            for protocolName in protocolNames {
                for type in valueTypes {
                    if type.implements.keys.contains(protocolName) {
                        if !types.contains(type.name) {
                            guard type.name != "Never" else { continue } // FIXME: solve Never issue
                            types.append(type.name)
                        }
                    }
                }
            }
            types.sort()
            types = types.filter { !$0.hasPrefix("_") }
            
            let matchingProtocols = protocols
                .filter { 1 == ($0.methods.count + $0.properties.count + $0.subscriptCount) }
                .map { $0.globalName }
                .sorted()
            
            let allParameterTypesAreSelf = method.parameters.contains { $0.type != "Self" }
            guard allParameterTypesAreSelf else {
                // TODO: support operators with non-Self parameters
                print("Skipping unsupported operator: \(signature)")
                continue
            }
            
            features.append(SwiftFeature(featureType: method.isOperator ? .operator : .method,
                                         featureName: name,
                                         signature: signature,
                                         available: method.available,
                                         callName: method.callName,
                                         returnType: returnTypeForOperatorInProtocol(method),
                                         types: types,
                                         protocols: protocolNames,
                                         matchingProtocols: matchingProtocols))
        }
        
        return features.sorted { $0.featureName > $1.featureName }
    }
}
