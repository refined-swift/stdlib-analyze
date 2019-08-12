import XCTest
@testable import SwiftFeature

final class StringAsciiNonControlCharacterNameTests: XCTestCase {
    func testAsciiNonControlCharacterName() {
        XCTAssertEqual("1".asciiNonControlCharacterName(), "digit 1")
    }
    
    static var allTests = [
        ("testAsciiNonControlCharacterName", testAsciiNonControlCharacterName),
    ]
}
