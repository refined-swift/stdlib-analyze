import Swift

extension String {
    public func removingSuffix(_ suffix: String) -> String{
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    public func removingPrefix(_ prefix: String) -> String{
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    public func removingCharacters(from forbiddenSet: CharacterSet) -> String {
        let valid = self.unicodeScalars.filter { !forbiddenSet.contains($0) }
        return String(String.UnicodeScalarView(valid))
    }
}
