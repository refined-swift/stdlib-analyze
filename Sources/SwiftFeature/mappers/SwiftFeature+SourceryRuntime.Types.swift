import Foundation
import SourceryRuntime
import SwiftTypes
import SwiftTypesMappers

extension SwiftFeature {
    /// Extracts features from the given SourceryRuntime types.
    public static func parse(sourceryTypes: SourceryRuntime.Types,
                             minimumCardinality: Int,
                             includeProperties: Bool = true,
                             includeOperators: Bool = true,
                             includeSubscripts: Bool = true,
                             includeUnavailable: Bool = false,
                             includeDeprecated: Bool = false,
                             includeRenamed: Bool = false,
                             includeObsoleted: Bool = false) -> [SwiftFeature] {
        var features = [SwiftFeature]()
        if includeProperties {
            features += parseProperties(in: sourceryTypes,
                                        minimumCardinality: minimumCardinality,
                                        includeUnavailable: includeUnavailable,
                                        includeDeprecated: includeDeprecated,
                                        includeRenamed: includeRenamed,
                                        includeObsoleted: includeObsoleted)
        }
        if includeOperators {
            features += parseOperators(in: sourceryTypes,
                                       minimumCardinality: minimumCardinality,
                                       includeUnavailable: includeUnavailable,
                                       includeDeprecated: includeDeprecated,
                                       includeRenamed: includeRenamed,
                                       includeObsoleted: includeObsoleted)
        }
        if includeSubscripts {
            features += parseSubscripts(in: sourceryTypes,
                                        minimumCardinality: minimumCardinality,
                                        includeUnavailable: includeUnavailable,
                                        includeDeprecated: includeDeprecated,
                                        includeRenamed: includeRenamed,
                                        includeObsoleted: includeObsoleted)
        }
        return features
    }
}
