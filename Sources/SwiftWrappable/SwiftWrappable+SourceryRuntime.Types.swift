import Swift
import SourceryRuntime
import SwiftTypes
import SwiftTypesMappers

extension SwiftWrappable {
    public static func parse(sourceryTypes: SourceryRuntime.Types) -> [SwiftWrappable] {
        let publicProtocols = sourceryTypes
            .protocols
            .map { SwiftProtocol($0, knownTypes: sourceryTypes.all.map { $0.name }) }.filter { $0.isPublic }
        
        let perfectlyWrappableProtocols = publicProtocols
            .filter { $0.isPublic }
            .filter { !$0.properties.contains { $0.isMutating } }
            .filter { !$0.methods.contains { $0.isMutating || $0.returnsSelf } }
            .filter { !$0.methods.contains { $0.isInit && !$0.isFailableInit && !$0.isThrowing } }
            .filter { !$0.methods.contains { !$0.isInit && !$0.isOperator } } // TODO: support methods
            .filter { $0.subscriptCount == 0 } // TODO: support immutable subscripts
            .filter { !$0.methods.isEmpty || !$0.properties.isEmpty /*|| !$0.subscripts.isEmpty*/ }
        // TODO: if they contain duplicated methods, split protocols into pieces
        
        var wrappables = [SwiftWrappable]()
        for aProtocol in perfectlyWrappableProtocols {
            var items = [SwiftWrappable.Member]()
            for method in aProtocol.methods {
                guard !operatorsDefinedInProtocolExtensions.contains(method.shortName) else {
                    print("Skipping operator defined in extension: \(method.shortName)")
                    continue
                }

                let member = Member(method: method, protocol: aProtocol)
                
                guard !(items.contains { $0.signature == member.signature }) else { // FIXME: get rid of repeated methods...
                    print("Skipping duplicate: \(member.signature)")
                    continue
                }
                
                items.append(member)
            }
            for property in aProtocol.properties {
                let member = SwiftWrappable.Member(property: property,
                                                   protocol: aProtocol)
                items.append(member)
            }
            wrappables.append(SwiftWrappable(protocolName: aProtocol.globalName, items: items, associatedTypes: aProtocol.associatedTypes))
        }
        
        return wrappables
    }
}
