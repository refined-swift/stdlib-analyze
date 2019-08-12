import Foundation
import SourceryRuntime
import SwiftTypes

extension SwiftAttribute {
    // swiftlint:disable:next function_body_length
    public init?(_ attribute: SourceryRuntime.Attribute) {
        guard AccessLevel(rawValue: attribute.description) == nil else { return nil }
        let isMutating = attribute.description == "mutating"
        let isAccessLevel = SourceryRuntime.AccessLevel(rawValue: attribute.description) != nil
        let isAvailability = attribute.description.hasPrefix("@available")
        let isDeprecated = attribute.arguments.keys.contains { $0.hasPrefix("deprecated") }
        let isUnavailable = attribute.arguments.keys.contains { $0.hasPrefix("unavailable") }
        let isRenamed = attribute.arguments.keys.contains { $0.hasPrefix("renamed") }
        let isObsoleted = attribute.arguments.keys.contains { $0.hasPrefix("obsoleted") }
        let isDiscardable = attribute.description == "@discardableResult"
        let isPublic = attribute.arguments.keys.contains { $0.hasPrefix("public") }
        let isFinal = attribute.description == "final"
        let isAlwaysEmitIntoClient = attribute.description == "@alwaysEmitIntoClient"
        let isObjC = attribute.description.hasPrefix("@objc(")

        var watchVersion: String?
        var macVersion: String?
        var tvVersion: String?
        var iVersion: String?

        if isAvailability && !isDeprecated && !isUnavailable && !isRenamed && !isObsoleted {
            for key in attribute.arguments.keys {
                if key.hasPrefix("watchOS_") {
                    watchVersion = key.removingPrefix("watchOS_")
                } else if key.hasPrefix("macOS_") {
                    macVersion = key.removingPrefix("macOS_")
                } else if key.hasPrefix("tvOS_") {
                    tvVersion = key.removingPrefix("tvOS_")
                } else if key.hasPrefix("iOS_") {
                    iVersion = key.removingPrefix("iOS_")
                }
            }
        }

        self = SwiftAttribute(serialize: attribute.description,
                              isMutating: isMutating,
                              isAccessLevel: isAccessLevel,
                              isAvailability: isAvailability,
                              isUnavailable: isUnavailable,
                              isDeprecated: isDeprecated,
                              isRenamed: isRenamed,
                              isObsoleted: isObsoleted,
                              isDiscardable: isDiscardable,
                              isPublic: isPublic,
                              isFinal: isFinal,
                              isAlwaysEmitIntoClient: isAlwaysEmitIntoClient,
                              isObjC: isObjC,
                              availableWatchVersion: watchVersion,
                              availableMacVersion: macVersion,
                              availableTvVersion: tvVersion,
                              availableIVersion: iVersion)
    }
}
