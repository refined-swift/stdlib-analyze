import XCTest
@testable import SwiftFeature

final class StringSnakeToCamelCasedTests: XCTestCase {
    func testSnakeToCamelCased() {
        XCTAssertEqual("lorem_ipsum".snakeToCamelCased(), "loremIpsum")
    }
    
    static var allTests = [
        ("testSnakeToCamelCased", testSnakeToCamelCased),
    ]
}
