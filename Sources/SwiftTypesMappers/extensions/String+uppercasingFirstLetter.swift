import Swift

extension String {
    // Source: https://stackoverflow.com/a/26306372/870560
    public func uppercasingFirstLetter() -> String {
        return prefix(1).uppercased() + self.dropFirst()
    }
}
