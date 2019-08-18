import Swift
import SourceryRuntime
import SwiftTypes
import SwiftTypesMappers

extension SwiftWrappable.Member {
    init(property: SwiftProperty, protocol: SwiftProtocol) {
        let returnType = normalizeReturnType(property.returnType,
                                             associatedTypes: `protocol`.associatedTypes)
        let signature = SwiftProperty.serialization(available: property.available,
                                                    attributes: property.attributes,
                                                    skipAttributes: false,
                                                    accessLevel: property.accessLevel,
                                                    writeAccessLevel: property.writeAccessLevel,
                                                    isStatic: property.isStatic,
                                                    isMutating: true,
                                                    name: property.name,
                                                    returnType: returnType,
                                                    isDefinedInProtocol: false)
        
        self = SwiftWrappable.Member(available: property.available,
                                     isStatic: property.isStatic,
                                     isMethod: false,
                                     isInit: false,
                                     isOperator: false,
                                     signature: signature,
                                     callName: property.name,
                                     parameters: [],
                                     isThrowing: false)
    }
}
