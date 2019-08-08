import Foundation

extension String {
    func toUnicodeName() -> String? {
        let mutableString = NSMutableString(string: self)
        guard mutableString.length == 1 else { return nil }
        CFStringTransform(mutableString, nil, kCFStringTransformToUnicodeName, false)
        guard mutableString.hasPrefix("\\N{") else { return nil }
        mutableString.replaceOccurrences(of: "\\N{", with: "", options: [], range: mutableString.range(of: mutableString as String))
        mutableString.replaceOccurrences(of: "}", with: "", options: [], range: mutableString.range(of: mutableString as String))
        return mutableString as String
    }
}
