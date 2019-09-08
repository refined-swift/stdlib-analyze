import Foundation
import Idioms
import SourceryRuntime
import SwiftTypes

extension SwiftAttribute {
    private typealias AvailableVersion = (
        watch: String?,
        mac: String?,
        tv: String?,
        iOS: String?
    )
    
    private static func availableVersions(_ attribute: SourceryRuntime.Attribute) -> AvailableVersion {
        var version = AvailableVersion(watch: nil, mac: nil, tv: nil, iOS: nil)
        for key in attribute.arguments.keys {
            if key.hasPrefix("watchOS_") {
                version.watch = key.removingPrefix("watchOS_")
            } else if key.hasPrefix("macOS_") {
                version.mac = key.removingPrefix("macOS_")
            } else if key.hasPrefix("tvOS_") {
                version.tv = key.removingPrefix("tvOS_")
            } else if key.hasPrefix("iOS_") {
                version.iOS = key.removingPrefix("iOS_")
            }
        }
        return version
    }

    /// Maps given SourceryRuntime attribute into an attribute object.
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

        let versions: AvailableVersion?

        if isAvailability && !isDeprecated && !isUnavailable && !isRenamed && !isObsoleted {
            versions = SwiftAttribute.availableVersions(attribute)
        } else {
            versions = nil
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
                              availableWatchVersion: versions?.watch,
                              availableMacVersion: versions?.mac,
                              availableTvVersion: versions?.tv,
                              availableIVersion: versions?.iOS)
    }
}
