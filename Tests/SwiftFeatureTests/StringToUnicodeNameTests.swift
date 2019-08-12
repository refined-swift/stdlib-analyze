import XCTest
@testable import SwiftFeature

final class StringToUnicodeNameTests: XCTestCase {
    func testToUnicodeName() {
        XCTAssertEqual("÷".toUnicodeName(), "DIVISION SIGN")
    }
    
    static var allTests = [
        ("testToUnicodeName", testToUnicodeName),
    ]
}
