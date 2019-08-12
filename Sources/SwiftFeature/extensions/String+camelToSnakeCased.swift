import Foundation

extension String {
    // Source: https://gist.github.com/ivanbruel/e72d938f49db64d2f5df09fb9420c1e2
    func camelToSnakeCased() -> String {
        let pattern = "([a-z0-9])([A-Z])"
        // swiftlint:disable:next force_try
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased()
    }
}
