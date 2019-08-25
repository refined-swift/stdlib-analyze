import Foundation
import SourceryRuntime
import SourcererArchiver
import SourcererUnarchiver
import SwiftTypes
import SwiftTypesMappers
import SwiftFeature
import SwiftWrappable

typealias SourceryType = /*SourceryRuntime.*/Type

// parse source

let ignoreUnknownArguments = true
let archive = GenerateTypesArchive().execute
let unarchive = UnarchiveTypesFromPath().execute

let typesArchivePath = try archive(ignoreUnknownArguments)
let sourceryTypes = try unarchive(typesArchivePath)

//////////////////////////////////////////////////////////////////////////////////

let jsonEncoder = JSONEncoder()

//////////////////////////////////////////////////////////////////////////////////

let features = SwiftFeature.parse(sourceryTypes: sourceryTypes,
                                  minimumCardinality: 1,
                                  includeSubscripts: false)

//////////////////////////////////////////////////////////////////////////////////

let maybeOutput = URL(fileURLWithPath: CommandLine.arguments[1])
    .appendingPathComponent("Maybe.json")

let maybeFeatures = features
    .filter { $0.featureType == .property }
    .filter { $0.featureName.hasPrefix("Maybe") }
    .filter { $0.matchingProtocols.count == 0 }

let maybeData = try jsonEncoder.encode(maybeFeatures)
try maybeData.write(to: maybeOutput)

////////////////////////////////////////////////////////////////////////////////

var propertiesOutput = URL(fileURLWithPath: CommandLine.arguments[1])
    .appendingPathComponent("Properties.json")

let propertiesFeatures = features
    .filter { $0.featureType == .property }
    .filter { !$0.featureName.hasPrefix("Maybe") }
    .filter { $0.matchingProtocols.count == 0 }
    .filter { $0.returnType != "Self" }
    .filter { $0.types.count > 1 }
    .filter { $0.protocols.count != 1 } // FIXME: this way you avoid dealing with
                                        //        most extensions with generic where clauses,
                                        //        which are not supported yet...
    .filter { !$0.featureName.hasPrefix("_") }
    .filter { feature in sourceryTypes.all.contains { $0.name == feature.returnType } }

let propertiesData = try jsonEncoder.encode(propertiesFeatures)
try propertiesData.write(to: propertiesOutput)

////////////////////////////////////////////////////////////////////////////////

var operatorsOutput = URL(fileURLWithPath: CommandLine.arguments[1])
    .appendingPathComponent("Operators.json")

let operatorsFeatures = features
    .filter { $0.featureType == .operator }
    .filter { $0.matchingProtocols.count == 0 }

let operatorsData = try jsonEncoder.encode(operatorsFeatures)
try operatorsData.write(to: operatorsOutput)

////////////////////////////////////////////////////////////////////////////////

let wrappableOutput = URL(fileURLWithPath: CommandLine.arguments[1])
    .appendingPathComponent("Wrappable.json")

let wrappables = SwiftWrappable.parse(sourceryTypes: sourceryTypes)

let wrappableData = try jsonEncoder.encode(wrappables)
try wrappableData.write(to: wrappableOutput)
