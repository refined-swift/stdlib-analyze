import Foundation
import Idioms
import SourceryRuntime
import SwiftTypes

private func appendTypes(_ types: [String],
                         to set: inout Set<String>,
                         knownTypes: [String],
                         excludedTypes: [String]) {
    for type in types {
        appendType(type,
                   to: &set,
                   knownTypes: knownTypes,
                   excludedTypes: excludedTypes)
    }
}

private func appendType(_ type: String,
                        to set: inout Set<String>,
                        knownTypes: [String],
                        excludedTypes: [String]) {
    let candidates = type
        .replacing(word: "inout", with: " ")
        .replacingOccurrences(of: "?", with: " ")
        .replacingOccurrences(of: "->", with: " ")
        .replacingOccurrences(of: "(", with: " ")
        .replacingOccurrences(of: ")", with: " ")
        .replacingOccurrences(of: "[", with: " ")
        .replacingOccurrences(of: "]", with: " ")
        .replacing(word: "throws", with: " ")
        .replacing(word: "rethrows", with: " ")
        .replacingOccurrences(of: ",", with: " ")
        .replacingOccurrences(of: "<", with: " ") // FIXME: move <...> to the beginning of the string
        .replacingOccurrences(of: ">", with: " ")
        .replacingOccurrences(of: " .", with: " ")
        .replacingOccurrences(of: "__owned", with: " ")
        .replacing(word: "where", with: " ")
        .replacingOccurrences(of: "==", with: " ")
        .replacingOccurrences(of: "@escaping", with: " ")
        .trimmingCharacters(in: .whitespaces)
        .components(separatedBy: " ")
        .reduce(into: [String]()) { result, component in
            guard !component.isEmpty else { return }
            guard component != "_" else { return }
            let colonComponents = component.components(separatedBy: ":")
            if let nonLabelComponent = colonComponents.last, colonComponents.count > 1 {
                result += [nonLabelComponent]
            } else {
                result += [component]
            }
        }
        .filter { !$0.isEmpty &&
            $0 != "Void" &&
            $0 != "Any" &&
            $0 != "AnyObject" &&
            !excludedTypes.contains($0) &&
            !knownTypes.contains($0) }
    candidates.forEach { set.insert($0) }
}

extension SourceryRuntime.SourceryProtocol {
    public func associatedTypes(knownTypes: [String]) -> [String] {
        let type = self
        
        let associatedTypes = Set<String>()
            .union(type.allMethods.reduce(into: Set<String>()) { result, method in
            
            let methodGenericParameters = method.genericParameters
            let paramaters: [MethodParameter] = method.parameters
            let paramTypes: [String] = paramaters.compactMap { parameter in
                guard parameter.type == nil else { return nil}
                return parameter.typeName.name
            }
            if method.returnType == nil {
                appendType(method.returnTypeName.name,
                           to: &result,
                           knownTypes: knownTypes,
                           excludedTypes: methodGenericParameters)
            }
            appendTypes(paramTypes,
                        to: &result,
                        knownTypes: knownTypes,
                        excludedTypes: methodGenericParameters)
        })
            .union(type.allVariables.reduce(into: Set<String>()) { result, variable in
            guard variable.type == nil else { return }
            appendType(variable.typeName.name,
                       to: &result,
                       knownTypes: knownTypes,
                       excludedTypes: [])
        })
            .union(type.allSubscripts.reduce(into: Set<String>()) { result, aSubscript in
            let subscripts: [MethodParameter] = aSubscript.parameters
            let paramTypes: [String] = subscripts.compactMap { parameter in
                guard parameter.type == nil else { return nil}
                return parameter.typeName.name
            }
            if aSubscript.returnType == nil {
                appendType(aSubscript.returnTypeName.name,
                           to: &result,
                           knownTypes: knownTypes,
                           excludedTypes: [])
            }
            appendTypes(paramTypes,
                        to: &result,
                        knownTypes: knownTypes,
                        excludedTypes: [])
        })
        
        return associatedTypes.sorted()
    }
}
