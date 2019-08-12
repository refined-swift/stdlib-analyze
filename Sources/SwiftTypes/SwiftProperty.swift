import Swift

public struct SwiftProperty: Codable, Equatable {
    public var serialize: String {
        let isDefinedInProtocol = self.isDefinedInProtocol ?? false
        return SwiftProperty.serialization(available: available,
                                           attributes: attributes,
                                           skipAttributes: false,
                                           accessLevel: accessLevel,
                                           writeAccessLevel: writeAccessLevel,
                                           isStatic: isStatic,
                                           isMutating: isMutating,
                                           name: name,
                                           returnType: returnType,
                                           isDefinedInProtocol: isDefinedInProtocol)
    }

    public let attributes: [SwiftAttribute]
    public let isMutating: Bool
    public let isStatic: Bool
    public let accessLevel: String
    public let definedInType: String

    public let writeAccessLevel: String
    public let name: String
    public let returnType: String
    public let isDefinedInProtocol: Bool?

    public var isPublic: Bool {
        return accessLevel == "public"
    }

    public var isUnavailable: Bool {
        return attributes.contains { $0.isUnavailable }
    }

    public var isDeprecated: Bool {
        return attributes.contains { $0.isDeprecated }
    }

    public var isRenamed: Bool {
        return attributes.contains { $0.isRenamed }
    }

    public var isObsoleted: Bool {
        return attributes.contains { $0.isObsoleted }
    }

    public var available: String {
        for attribute in attributes {
            let available = attribute.serializeAvailablePlatforms()
            guard available.isEmpty else { return available }
        }
        return ""
    }

    public init(attributes: [SwiftAttribute],
                isMutating: Bool,
                isStatic: Bool,
                accessLevel: String,
                definedInType: String,
                writeAccessLevel: String,
                name: String,
                returnType: String,
                isDefinedInProtocol: Bool) {
        self.attributes = attributes
        self.isMutating = isMutating
        self.isStatic = isStatic
        self.accessLevel = accessLevel
        self.definedInType = definedInType
        self.writeAccessLevel = writeAccessLevel
        self.name = name
        self.returnType = returnType
        self.isDefinedInProtocol = isDefinedInProtocol
    }

    public static func serialization(available: String,
                                     attributes: [SwiftAttribute],
                                     skipAttributes: Bool,
                                     accessLevel: String,
                                     writeAccessLevel: String,
                                     isStatic: Bool,
                                     isMutating: Bool,
                                     name: String,
                                     returnType: String,
                                     isDefinedInProtocol: Bool) -> String {
        var string: String
        if !skipAttributes {
            string = attributes.filter { $0.isAccessLevel == false }.map { $0.serialize }.joined(separator: " ")
            string += attributes.isEmpty ? "" : " "
        } else {
            string = available
            string += string.isEmpty ? "" : " "
        }
        string += isDefinedInProtocol ? "" : accessLevel
        string += isDefinedInProtocol ? "" : " "
        if isMutating && !writeAccessLevel.isEmpty && writeAccessLevel != accessLevel {
            string += writeAccessLevel
            string += "(set)"
            string += " "
        }
        if isDefinedInProtocol {
            string += isMutating ? "var " : "var "
        } else {
            string += isMutating ? "var " : "let "
        }
        string += name
        string += ": "
        string += returnType
        if isDefinedInProtocol {
            string += " "
            string += isMutating ? "{ get set }" : "{ get }"
        }
        return string.trimmingCharacters(in: .whitespaces)
    }
}
