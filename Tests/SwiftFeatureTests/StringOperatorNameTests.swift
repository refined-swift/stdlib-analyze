import XCTest
@testable import SwiftFeature

final class StringOperatorNameTests: XCTestCase {
    func testOperatorName() {
        XCTAssertEqual(String.operatorName("==", type: nil), "Equal")
    }
    
    func testPrefixOperatorName() {
        XCTAssertEqual(String.operatorName("-", type: .prefix), "Minus")
    }
    
    static var allTests = [
        ("testOperatorName", testOperatorName),
        ("testPrefixOperatorName", testPrefixOperatorName),
    ]
}
