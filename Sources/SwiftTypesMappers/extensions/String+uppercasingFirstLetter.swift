import Swift

extension String {
    /// Returns a copy of the receiver with its character uppercased.
    /// Source: https://stackoverflow.com/a/26306372/870560
    public func uppercasingFirstLetter() -> String {
        return prefix(1).uppercased() + self.dropFirst()
    }
}
