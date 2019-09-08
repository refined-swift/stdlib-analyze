import Foundation
import SourceryRuntime
import SwiftTypes

extension SourceryRuntime.SourceryMethod {
    /// Returns generic parameters of the receiver method.
    public var genericParameters: [String] {
        return name
            .components(separatedBy: "(")
            .dropLast()
            .joined(separator: "(")
            .components(separatedBy: "<")
            .dropFirst()
            .joined(separator: "<")
            .components(separatedBy: ">")
            .dropLast()
            .joined(separator: ">")
            .components(separatedBy: ":")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: ":")
            .components(separatedBy: CharacterSet(charactersIn: ", "))
            .map { $0.contains(":") ? $0.components(separatedBy: ":").dropLast().joined(separator: ":") : $0 }
            .filter { !$0.isEmpty }
    }
}
