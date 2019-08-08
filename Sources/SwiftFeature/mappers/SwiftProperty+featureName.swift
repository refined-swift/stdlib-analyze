import Swift
import SwiftTypes

extension SwiftProperty {
    func featureName() -> String {
        let snake = name.camelToSnakeCased()
        if snake.hasPrefix("is_") {
            let removingIsPrefix = Array(snake.components(separatedBy: "_").dropFirst()).joined(separator: "_").snakeToCamelCased()
            return "Maybe\(removingIsPrefix.uppercasingFirstLetter())"
        } else if name.hasSuffix("ed") {
            return "\(name.uppercasingFirstLetter().removingSuffix("d"))able"
        } else if name.hasSuffix("y") {
            return "\(name.uppercasingFirstLetter())ing"
        } else if name.hasSuffix("ent") {
            return "\(name.uppercasingFirstLetter())iable"
        } else {
            return "\(name.uppercasingFirstLetter())able"
        }
    }
}
