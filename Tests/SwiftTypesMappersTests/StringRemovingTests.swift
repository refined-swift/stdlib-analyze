import XCTest
@testable import SwiftTypesMappers

final class StringRemovingTests: XCTestCase {
    func testRemovingSuffix() {
        XCTAssertEqual("lorem".removingSuffix("orem"), "l")
    }
    
    func testRemovingPrefix() {
        XCTAssertEqual("lorem".removingPrefix("lore"), "m")
    }
    
    func testRemovingCharacters() {
        XCTAssertEqual("lorem ipsum".removingCharacters(from: .whitespaces), "loremipsum")
    }
    
    static var allTests = [
        ("testRemovingSuffix", testRemovingSuffix),
        ("testRemovingPrefix", testRemovingPrefix),
        ("testRemovingCharacters", testRemovingCharacters),
    ]
}

