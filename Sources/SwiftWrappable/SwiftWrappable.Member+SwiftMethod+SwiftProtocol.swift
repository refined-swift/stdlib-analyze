import Swift
import SourceryRuntime
import SwiftTypes
import SwiftTypesMappers

extension SwiftWrappable.Member {
    init(method: SwiftMethod, protocol: SwiftProtocol) {
        var parameters = [SwiftMethod.Parameter]()
        for parameter in method.parameters {
            parameters.append(SwiftMethod.Parameter(label: parameter.externalLabel,
                                                    internalName: parameter.internalName,
                                                    position: parameter.position,
                                                    type: normalizeReturnType(parameter.type, associatedTypes: `protocol`.associatedTypes),
                                                    isInOut: parameter.isInOut,
                                                    isEscaping: parameter.isEscaping,
                                                    isOwned: parameter.isOwned,
                                                    isSelf: parameter.isSelf))
        }
        let signature = SwiftMethod.serialization(available: method.available,
                                                  attributes: method.attributes,
                                                  skipAttributes: false,
                                                  accessLevel: method.accessLevel,
                                                  isStatic: method.isStatic,
                                                  isInit: method.isInit,
                                                  isFailableInit: method.isFailableInit,
                                                  isOperator: method.isOperator,
                                                  shortName: method.shortName,
                                                  parameters: parameters,
                                                  isThrowing: method.isThrowing,
                                                  isRethrowing: method.isRethrowing,
                                                  returnType: normalizeReturnType(method.returnType, associatedTypes: `protocol`.associatedTypes),
                                                  isDefinedInProtocol: false)
        
        self = SwiftWrappable.Member(available: method.available,
                                     isStatic: method.isStatic,
                                     isMethod: true,
                                     isInit: method.isInit,
                                     isOperator: method.isOperator,
                                     signature: signature,
                                     callName: method.callName,
                                     parameters: method.parameters.map {
                                        SwiftWrappable.Parameter(externalLabel: $0.externalLabel, internalName: $0.internalName) },
                                     isThrowing: method.isThrowing)
    }
}
