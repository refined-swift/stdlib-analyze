import Swift

extension String {
    func snakeToCamelCased() -> String {
        return split(separator: "_")
            .enumerated()
            .map { (index, element) in
                return index > 0 ? String(element).capitalized : String(element)
            }.joined()
    }
}
