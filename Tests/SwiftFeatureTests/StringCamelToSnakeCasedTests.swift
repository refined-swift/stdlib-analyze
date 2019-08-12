import XCTest
@testable import SwiftFeature

final class StringCamelToSnakeCasedTests: XCTestCase {
    func testCamelToSnakeCased() {
        XCTAssertEqual("loremIpsum".camelToSnakeCased(), "lorem_ipsum")
    }
    
    static var allTests = [
        ("testCamelToSnakeCased", testCamelToSnakeCased),
    ]
}
