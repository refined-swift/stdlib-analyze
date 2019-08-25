import Foundation
import SourceryRuntime
import SwiftTypes

extension SwiftMethod {
    private static func buildReturnType(_ typeName: SourceryRuntime.TypeName) -> String {
        var string = typeName.name
        if string.hasPrefix("where") {
            string = "Void \(string)"
        }
        string = string.components(separatedBy: " ")
            .map { $0.trimmingCharacters(in: .newlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        return string
    }

    public init(_ method: SourceryRuntime.SourceryMethod, typeName: String) {
        let returnType = SwiftMethod.buildReturnType(method.returnTypeName)
        let simplifiedType = returnType
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: "->", with: "")
        let actualReturnType = SwiftMethod.buildReturnType(method.actualReturnTypeName)

        let isStatic = method.isStatic
        let isOperator = method.callName.rangeOfCharacter(from: .symbols) != nil ||
            method.callName.uppercased() == method.callName.lowercased() ||
            method.callName.uppercasingFirstLetter().isEmpty
        let isInit = method.isInitializer || method.isFailableInitializer
        let returnsVoid = simplifiedType == "Void" || simplifiedType.hasPrefix("Void ") || (simplifiedType.isEmpty && !isInit) || returnType == "()"
        let returnsSelf = simplifiedType == "Self" || simplifiedType.hasPrefix("Self ") || simplifiedType.hasSuffix(" Self")
        let hasWhere = returnType.contains(" where ")
        let shortName = method.shortName.trimmingCharacters(in: .whitespaces)
        var callName = method.callName.trimmingCharacters(in: .whitespaces)
        if let nonEmptyName = method.shortName.components(separatedBy: " ").first, callName.isEmpty {
            callName = nonEmptyName
        }
        self = SwiftMethod(definedInType: method.definedInType?.name ?? typeName,
                           attributes: method.attributes.values.compactMap(SwiftAttribute.init),
                           callName: isOperator ? shortName : callName,
                           shortName: shortName,
                           genericParameters: method.genericParameters,
                           parameters: method.parameters.map { SwiftMethod.Parameter($0, method: method) },
                           accessLevel: method.accessLevel,
                           isInit: isInit,
                           isFailableInit: method.isFailableInitializer,
                           isStatic: isStatic,
                           isOperator: isOperator,
                           returnsVoid: returnsVoid,
                           returnsSelf: returnsSelf,
                           hasWhere: hasWhere,
                           isThrowing: method.throws,
                           isRethrowing: method.rethrows,
                           returnType: returnType,
                           actualReturnType: actualReturnType,
                           isDefinedInProtocol: (method.definedInType as? SourceryRuntime.SourceryProtocol != nil))
    }
}
