import Foundation
import SourceryRuntime
import SwiftTypes
import SwiftTypesMappers

extension SwiftFeature {
    // swiftlint:disable:next function_body_length
    static func parseProperties(in sourceryTypes: SourceryRuntime.Types,
                                minimumCardinality: Int,
                                includeUnavailable: Bool,
                                includeDeprecated: Bool,
                                includeRenamed: Bool,
                                includeObsoleted: Bool) -> [SwiftFeature] {
        let publicProtocols = sourceryTypes.protocols.map { SwiftProtocol($0, knownTypes: sourceryTypes.all.map { $0.name }) }.filter { $0.isPublic }
        let nonProtocolPublicProperties = sourceryTypes
            .all
            .filter { /* !($0 is SourceryProtocol) &&*/ $0.accessLevel == "public" }
            .flatMap { type in
                return type.variables.map { SwiftProperty($0, typeName: type.name) }
            }
            .filter { $0.isPublic &&
                !$0.isMutating &&
                !$0.isStatic &&
                (!$0.isUnavailable || includeUnavailable) &&
                (!$0.isDeprecated || includeDeprecated) &&
                (!$0.isRenamed || includeRenamed) &&
                (!$0.isObsoleted || includeObsoleted) }

        var allProperties = [String: SwiftProperty]()
        var names = [String: String]()

        let crossReference = Dictionary(grouping: nonProtocolPublicProperties,
                                        by: { (property: SwiftProperty) -> String in
            //let returnType = property.returnType == property.definedInType ||
            //    property.returnType.hasPrefix("\(property.definedInType!) ") ? "Self" : property.returnType
            let returnType = property.returnType != "Self" ? property.returnType : property.definedInType

            let signature = SwiftProperty.serialization(available: property.available,
                                                        attributes: property.attributes,
                                                        skipAttributes: true,
                                                        accessLevel: property.accessLevel,
                                                        writeAccessLevel: property.writeAccessLevel,
                                                        isStatic: property.isStatic,
                                                        isMutating: property.isMutating,
                                                        name: property.name,
                                                        returnType: returnType,
                                                        isDefinedInProtocol: true)
            names[signature] = property.featureName()
            allProperties[signature] = property

            return signature
        })

        let duplicates: [String] = crossReference
            .filter { $1.count >= minimumCardinality }
            .compactMap { $0.0 }

        var features = [SwiftFeature]()
        for signature in duplicates {
            guard let properties = crossReference[signature] else { continue }
            var protocols = [SwiftProtocol]()
            for aProtocol in publicProtocols {
                if (aProtocol.properties.map { $0.serialize }).contains(signature) {
                    protocols.append(aProtocol)
                }
            }

            let property = allProperties[signature]!
            let name = names[signature]!
            let protocolNames = protocols
                .map { $0.globalName }
                .sorted()

            let valueTypes = sourceryTypes.structs + sourceryTypes.enums

            var types = properties.map { $0.definedInType }
            for protocolName in protocolNames {
                for type in valueTypes {
                    if type.implements.keys.contains(protocolName) {
                        if !types.contains(type.name) {
                            guard (type.name != "Range" && type.name != "ClosedRange") ||
                                name != "Countable" else { // FIXME: support generic where clauses
                                print("Skipping \(type.name) due to unsupported generic where clause...")
                                continue
                            }
                            types.append(type.name)
                        }
                    }
                }
            }
            types.sort()
            types = types.filter { !$0.hasPrefix("_") && !$0.hasSuffix("_") }
            guard types.count > 0 else {
                continue
            }

            let matchingProtocols = protocols
                .filter { 1 == ($0.methods.count + $0.properties.count + $0.subscriptCount) }
                .map { $0.globalName }
                .sorted()

            features.append(SwiftFeature(featureType: .property,
                                         featureName: name,
                                         signature: signature,
                                         available: property.available,
                                         callName: property.name,
                                         returnType: property.returnType,
                                         types: types,
                                         protocols: protocolNames,
                                         matchingProtocols: matchingProtocols))
        }

        return features.sorted { $0.featureName > $1.featureName }

    }
}
