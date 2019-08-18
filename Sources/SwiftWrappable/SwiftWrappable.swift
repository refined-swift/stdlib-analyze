import Swift
import SwiftTypes
import SwiftTypesMappers

public struct SwiftWrappable: Codable, Equatable {
    public struct Member: Codable, Equatable {
        public let available: String
        public let isStatic: Bool
        public let isMethod: Bool
        public let isInit: Bool
        public let isOperator: Bool
        public let signature: String
        public let callName: String
        public let parameters: [Parameter]
        public let isThrowing: Bool
        
        public init(available: String,
                    isStatic: Bool,
                    isMethod: Bool,
                    isInit: Bool,
                    isOperator: Bool,
                    signature: String,
                    callName: String,
                    parameters: [Parameter],
                    isThrowing: Bool) {
            self.available = available
            self.isStatic = isStatic
            self.isMethod = isMethod
            self.isInit = isInit
            self.isOperator = isOperator
            self.signature = signature
            self.callName = callName
            self.parameters = parameters
            self.isThrowing = isThrowing
        }
    }
    
    public struct Parameter: Codable, Equatable {
        public let externalLabel: String
        public let internalName: String
        
        public init(externalLabel: String,
                    internalName: String) {
            self.externalLabel = externalLabel
            self.internalName = internalName
        }
    }
    
    public let protocolName: String
    public let items: [Member]
    public let associatedTypes: [String]
    
    public init(protocolName: String,
                items: [Member],
                associatedTypes: [String]) {
        self.protocolName = protocolName
        self.items = items
        self.associatedTypes = associatedTypes
    }
}
