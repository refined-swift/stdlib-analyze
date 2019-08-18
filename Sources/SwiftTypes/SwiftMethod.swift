import Swift

public struct SwiftMethod: Codable, Equatable {
    public struct Parameter: Codable, Equatable {
        public var serialize: String {
            var string = externalLabel
            if externalLabel != internalName {
                string += " "
                string += internalName
            }
            string += ":"
            string += " "
            string += type
            return string
        }

        public let externalLabel: String
        public let internalName: String
        public let type: String

        public let isInOut: Bool
        public let isEscaping: Bool
        public let isOwned: Bool
        public let isSelf: Bool
  
        public init(label: String,
                    internalName: String,
                    type: String,
                    isInOut: Bool,
                    isEscaping: Bool,
                    isOwned: Bool,
                    isSelf: Bool) {
            self.externalLabel = label
            self.internalName = internalName
            self.type = type
            self.isInOut = isInOut
            self.isEscaping = isEscaping
            self.isOwned = isOwned
            self.isSelf = isSelf
        }
    }

    public var serialize: String {
        let isDefinedInProtocol = self.isDefinedInProtocol ?? false
        return SwiftMethod.serialization(available: available,
                                         attributes: attributes,
                                         skipAttributes: false,
                                         accessLevel: accessLevel,
                                         isStatic: isStatic,
                                         isInit: isInit,
                                         isFailableInit: isFailableInit,
                                         isOperator: isOperator,
                                         shortName: shortName,
                                         parameters: parameters,
                                         isThrowing: isThrowing,
                                         isRethrowing: isRethrowing,
                                         returnType: returnType,
                                         isDefinedInProtocol: isDefinedInProtocol)
    }

    public var isPublic: Bool {
        return accessLevel == "public"
    }

    public var isMutating: Bool {
        return attributes.contains { $0.isMutating }
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

    public let definedInType: String

    public let attributes: [SwiftAttribute]
    public let callName: String
    public let shortName: String
    public let genericParameters: [String]
    public let parameters: [Parameter]
    public let accessLevel: String

    public let isInit: Bool
    public let isFailableInit: Bool
    public let isStatic: Bool
    public let isOperator: Bool
    public let returnsVoid: Bool
    public let returnsSelf: Bool
    public let hasWhere: Bool
    public let isThrowing: Bool
    public let isRethrowing: Bool

    public let returnType: String
    public let actualReturnType: String
    public let isDefinedInProtocol: Bool?

    public var available: String {
        for attribute in attributes {
            let available = attribute.serializeAvailablePlatforms()
            guard available.isEmpty else { return available }
        }
        return ""
    }

    public init(definedInType: String,
                attributes: [SwiftAttribute],
                callName: String,
                shortName: String,
                genericParameters: [String],
                parameters: [SwiftMethod.Parameter],
                accessLevel: String,
                isInit: Bool,
                isFailableInit: Bool,
                isStatic: Bool,
                isOperator: Bool,
                returnsVoid: Bool,
                returnsSelf: Bool,
                hasWhere: Bool,
                isThrowing: Bool,
                isRethrowing: Bool,
                returnType: String,
                actualReturnType: String,
                isDefinedInProtocol: Bool) {
        self.definedInType = definedInType
        self.attributes = attributes
        self.callName = callName
        self.shortName = shortName
        self.genericParameters = genericParameters
        self.parameters = parameters
        self.accessLevel = accessLevel
        self.isInit = isInit
        self.isFailableInit = isFailableInit
        self.isStatic = isStatic
        self.isOperator = isOperator
        self.returnsVoid = returnsVoid
        self.returnsSelf = returnsSelf
        self.hasWhere = hasWhere
        self.isThrowing = isThrowing
        self.isRethrowing = isRethrowing
        self.returnType = returnType
        self.actualReturnType = actualReturnType
        self.isDefinedInProtocol = isDefinedInProtocol
    }

    public static func serialization(available: String,
                                     attributes: [SwiftAttribute],
                                     skipAttributes: Bool,
                                     accessLevel: String,
                                     isStatic: Bool,
                                     isInit: Bool,
                                     isFailableInit: Bool,
                                     isOperator: Bool,
                                     shortName: String,
                                     parameters: [Parameter],
                                     isThrowing: Bool,
                                     isRethrowing: Bool,
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
        string += isStatic && !isInit ? "static " : ""
        if isFailableInit {
            string += "init?"
        } else if isInit {
            string += "init"
        } else {
            string += "func"
            string += " "
            string += shortName.trimmingCharacters(in: .whitespaces)
        }
        if isOperator {
            string += " "
        }
        string += "("
        string += parameters.map { $0.serialize }.joined(separator: ", ")
        string += ")"
        string += " "
        string += (isThrowing ? "throws " : isRethrowing ? "rethrows " : "")
        if !isInit {
            string += "->"
            string += " "
            string += returnType
        }
        return string.trimmingCharacters(in: .whitespaces)
    }
}
