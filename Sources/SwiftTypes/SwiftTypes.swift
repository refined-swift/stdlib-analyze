import Swift

/// Types that are expected to exist in any version of the Swift Standard Library.
public let wellKnownTypes = ["Any", "AnyObject", "CodingKey", "Decoder", "Optional", "Dictionary", "Array"]

/// Typealias that are expected to exist in any version of the Swift Standard Library.
public let wellKnownTypealiases = ["LazyCollection": "LazySequence"]

/// Operators that are known to be defined in a protocol extension.
public let operatorsDefinedInProtocolExtensions = ["...", ">", "<=", ">=", "..<"]
