import XCTest
@testable import SwiftFeature

final class StringOperatorNameTests: XCTestCase {
    func testOperatorName() {
        XCTAssertEqual(String.operatorName("=="), "Equal to")
    }
    
    static var allTests = [
        ("testOperatorName", testOperatorName),
    ]
}
