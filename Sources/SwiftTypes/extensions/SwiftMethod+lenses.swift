import Swift

extension SwiftMethod {
    /// Returns a copy of the receiver updated with the given parameters array.
    public func updatingParameters(to parameters: [SwiftMethod.Parameter]) -> SwiftMethod {
        return SwiftMethod(definedInType: definedInType,
                           attributes: attributes,
                           callName: callName,
                           shortName: shortName,
                           genericParameters: genericParameters,
                           parameters: parameters,
                           accessLevel: accessLevel,
                           isInit: isInit,
                           isFailableInit: isFailableInit,
                           isStatic: isStatic,
                           isOperator: isOperator,
                           returnsVoid: returnsVoid,
                           returnsSelf: returnsSelf,
                           hasWhere: hasWhere,
                           isThrowing: isThrowing,
                           isRethrowing: isRethrowing,
                           returnType: returnType,
                           actualReturnType: actualReturnType,
                           isDefinedInProtocol: isDefinedInProtocol)
    }
}
