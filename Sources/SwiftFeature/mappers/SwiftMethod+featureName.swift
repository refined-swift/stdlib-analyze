import Swift
import SwiftTypes

extension SwiftMethod {
    func featureName(prefix: String? = nil, suffix: String? = nil) -> String {
        let name: String
        if self.isOperator {
            name = operatorFeatureName(prefix: prefix, suffix: suffix)
        } else {
            name = methodFeatureName(prefix: prefix, suffix: suffix)
        }
        return name.removingCharacters(from: CharacterSet.alphanumerics.inverted).uppercasingFirstLetter()
    }

    // swiftlint:disable:next function_body_length
    private func operatorFeatureName(prefix: String? = nil, suffix: String? = nil) -> String {
        if let operatorName = String.operatorName(callName) {
            let name = (prefix ?? "") + operatorName
                .components(separatedBy: " ")
                .map { $0.uppercasingFirstLetter() }
                .joined(separator: "")
                .components(separatedBy: "_")
                .joined(separator: "") + (suffix ?? "")
            if name.hasSuffix("on") {
                return "\(name)able"
            } else if name.hasSuffix("ed") {
                return "\(name.removingSuffix("d"))able"
            } else if name.hasSuffix("y") {
                return "\(name)ing"
            } else {
                return "\(name)Compatible"
            }
        } else if let unicodeName = callName.toUnicodeName() {
            let name = (prefix ?? "") + unicodeName
                .components(separatedBy: " ")
                .map { $0.uppercasingFirstLetter() }
                .joined(separator: "")
                .components(separatedBy: "_")
                .joined(separator: "") + (suffix ?? "")
            return "\(name)OperatorCompatible"
        } else if let characterName = callName.asciiNonControlCharacterName() {
            let name = (prefix ?? "") + characterName
                .components(separatedBy: " ")
                .map { $0.uppercasingFirstLetter() }
                .joined(separator: "")
                .components(separatedBy: "_")
                .joined(separator: "") + (suffix ?? "")
            return "\(name)OperatorCompatible"
        } else {
            let mutableString = NSMutableString(string: callName)
            CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
            CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, false)
            var components = [String]()
            for character in (mutableString as String) {
                guard let name = String.asciiNonControlCharacterName(character) else { continue }
                components.append(name)
            }
            let name = (prefix ?? "") + components
                .joined(separator: " ")
                .components(separatedBy: " ")
                .map { $0.uppercasingFirstLetter() }
                .joined(separator: "") + (suffix ?? "")
            return "\(name)OperatorCompatible"
        }
    }

    private func methodFeatureName(prefix: String? = nil, suffix: String? = nil) -> String {
        let name = callName.uppercasingFirstLetter()
        //for parameter in parameters {
        //    let label = parameter
        //        .label
        //        .components(separatedBy: " ")
        //        .map { $0.uppercasingFirstLetter() }
        //        .joined(separator: "")
        //        .components(separatedBy: "_")
        //        .joined(separator: "")
        //    let type = parameter
        //        .type
        //        .components(separatedBy: "<")
        //        .first!
        //        .components(separatedBy: " ")
        //        .map { $0.uppercasingFirstLetter() }
        //        .joined(separator: "")
        //        .components(separatedBy: "_")
        //        .joined(separator: "")
        //    name.append(label)
        //    //if !name.contains(type) {
        //    //    name.append(type)
        //    //}
        //}
        if returnsVoid {
            return "\(isStatic ? "Static" : "")\(prefix ?? "")\(name)\(suffix ?? "")"
        } else {
            let returnType = self.returnType
                .components(separatedBy: "<")
                .first!
                .removingSuffix("?")
                .removingSuffix("?")
            if name.contains(returnType) {
                return "\(isStatic ? "Static" : "")\(prefix ?? "")\(name)\(suffix ?? "")"
            } else {
                return "\(isStatic ? "Static" : "")\(prefix ?? "")\(name)\(suffix ?? "")As\(returnType)"
            }
        }
    }
}
